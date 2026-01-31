#encoding: utf-8
class Pessoa < ActiveRecord::Base
  audited

  attr_accessor :auto_sync

  before_save :set_uuid!
  after_create :criar_cliente
  after_save :sync_crm!, if: :auto_sync

  has_one :cliente
  has_one :funcionario
  has_one :pessoa_fisica, dependent: :destroy
  has_one :pessoa_juridica, dependent: :destroy
  has_one :pessoa_endereco, dependent: :destroy
  has_many :pessoas_contatos, dependent: :destroy

  # accepts_nested_attributes_for :casein_admin_user, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :pessoa_fisica, :reject_if => :valida_juridica, :allow_destroy => true
  accepts_nested_attributes_for :pessoa_juridica, :reject_if => :valida_fisica, :allow_destroy => true
  accepts_nested_attributes_for :pessoa_endereco, :allow_destroy => true
  accepts_nested_attributes_for :pessoas_contatos, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :nome, -> nome { where("nome ILIKE ?", "%#{nome}%") }
  scope :tipo, -> tipo { where(tipo: tipo) }
  scope :cpf, -> cpf { joins(:pessoa_fisica).where(pessoas_fisicas: { cpf: cpf }) }
  scope :cnpj, -> cnpj { joins(:pessoa_juridica).where(pessoas_juridicas: { cnpj: cnpj }) }

  validates :nome, presence: true
  # validates :email_xml, presence: true, :if => Proc.new { |a| a[:tipo] }

  def auto_sync
    @auto_sync = true if @auto_sync.nil?
    @auto_sync
  end

  def cpf_cnpj
    if tipo? && pessoa_juridica
      pessoa_juridica.cnpj
    elsif pessoa_fisica
      pessoa_fisica.cpf
    end
  end


  private

  def set_uuid!
    self.uuid ||= SecureRandom.uuid
  end

  def valida_fisica
    !tipo?
  end

  def valida_juridica
    tipo?
  end

  def criar_cliente
    Cliente.create(pessoa_id: self.id)
  end


  def sync_crm!
    body = {data: {
      uuid:         uuid,
      individuals: !tipo?,
      name:        nome,
      email:       email_contato,
      email_nfe:   email_xml,
      phone:       telefone_principal,
    }}

    if tipo? && pessoa_juridica # Juridica
      body[:data].merge!({
        cpf_cnpj:               pessoa_juridica.cnpj,
        state_registration:     pessoa_juridica.ie,
        municipal_registration: pessoa_juridica.im,
        birth_date:             pessoa_juridica.data_fundacao
      })
    elsif pessoa_fisica
      body[:data].merge!({
        cpf_cnpj:   pessoa_fisica.cpf,
        rg:         pessoa_fisica.rg,
        birth_date: pessoa_fisica.data_nascimento,
        cell_phone: pessoa_fisica.telefone_auxiliar_1
      })
    end

    if(pessoa_endereco)
      body[:data][:address] = {
        uf:          pessoa_endereco.try(:cidade).try(:estado).try(:sigla),
        city_name:   pessoa_endereco.try(:cidade).try(:nome),
        rua:         pessoa_endereco.endereco,
        numero:      pessoa_endereco.numero,
        bairro:      pessoa_endereco.bairro,
        complemento: pessoa_endereco.complemento,
        cep:         pessoa_endereco.cep,
        description: pessoa_endereco.tipo_endereco,
      }
    end

    sync_crm_request!(body)
  end

  def sync_crm_request!(body)
    url = URI("#{ENV['CRM_SYNC_HOST']}/sync/people")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request["Auth-Token"] = ENV['CRM_SYNC_TOKEN']
    request["Content-Type"] = "application/json"
    request.body = body.to_json

    http.use_ssl = url.port == 443

    begin http.request(request) rescue nil end
  end
end