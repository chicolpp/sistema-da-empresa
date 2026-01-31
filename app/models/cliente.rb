class Cliente < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
  has_many :pos_vendas
  has_many :orcamentos
  has_many :pocos
  has_many :casein_admin_users

  after_commit :create_poco!, on: [:create]
  
  accepts_nested_attributes_for :pessoa, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :nome, -> nome { joins(:pessoa).where("pessoas.nome ILIKE ?", "%#{nome}%") }
  scope :tipo, -> tipo { joins(:pessoa).where(pessoas: { tipo: tipo }) }
  scope :estado_id, -> estado_id { joins(pessoa: [pessoa_endereco: [cidade: :estado]]).where(estados: { id: estado_id }) }
  scope :cidade_id, -> cidade_id { joins(pessoa: :pessoa_endereco).where(pessoas_enderecos: { cidade_id: cidade_id }) }

  validates :data_inicio, presence: true, :if => Proc.new { |a| !a[:data_final].blank? }
  validates :data_final, presence: true, :if => Proc.new { |a| !a[:data_inicio].blank? }

  def cidade
    pessoa.try(:pessoa_endereco).try(:cidade)
  end

  private

  def create_poco!
    linha = [
      pessoa.try(:pessoa_endereco).try(:endereco),
      pessoa.try(:pessoa_endereco).try(:bairro)
    ].compact.join(' - ')

    Poco.create(
      poco_produtivo: true,
      cliente: self,
      linha_endereco: linha.presence || 'NÃO DEFINIDO',
      apelido_endereco: 'Poço Padrão',
      perfuracao_leao: false,
      cidade: pessoa.try(:pessoa_endereco).try(:cidade) || default_city
    )
  end

  def default_city
    Cidade.find_or_create_by(nome: 'NÃO DEFINIDO') { |c| c.estado = Estado.first }
  end
end
