#encoding: utf-8
class Pessoa < ActiveRecord::Base
  audited

  after_create :criar_cliente

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
  scope :nome, -> nome { where("nome LIKE '%#{nome}%'") }
  scope :tipo, -> tipo { where("tipo = '#{tipo}'") }
  scope :cpf, -> cpf { joins(:pessoa_fisica).where("cpf = '#{cpf}'") }
  scope :cnpj, -> cnpj { joins(:pessoa_juridica).where("cnpj = '#{cnpj}'") }

  validates :nome, presence: true
  # validates :email_xml, presence: true, :if => Proc.new { |a| a[:tipo] }

  private

  def valida_fisica
    !tipo?
  end

  def valida_juridica
    tipo?
  end

  def criar_cliente
    Cliente.create(pessoa_id: self.id)
  end
end