class Cliente < ActiveRecord::Base
  audited
  
  belongs_to :pessoa
  has_many :pos_vendas
  has_many :orcamentos
  has_many :pocos
  has_many :casein_admin_users
  
  accepts_nested_attributes_for :pessoa, :reject_if => :all_blank, :allow_destroy => true

  #Escopos para filtros de busca
  scope :nome, -> nome { joins(:pessoa).where("nome LIKE '%#{nome}%'") }
  scope :tipo, -> tipo { joins(:pessoa).where("tipo = '#{tipo}'") }
  scope :estado_id, -> estado_id { joins("JOIN pessoas p ON clientes.pessoa_id = p.id JOIN pessoas_enderecos pe ON pe.pessoa_id = p.id JOIN cidades ON cidades.id = pe.cidade_id JOIN estados ON cidades.estado_id = estados.id").where("estados.id = '#{estado_id}'")}
  scope :cidade_id, -> cidade_id { joins("JOIN pessoas pc ON clientes.pessoa_id = pc.id JOIN pessoas_enderecos pce ON pce.pessoa_id = pc.id").where("pce.cidade_id = '#{cidade_id}'") }

  validates :data_inicio, presence: true, :if => Proc.new { |a| !a[:data_final].blank? }
  validates :data_final, presence: true, :if => Proc.new { |a| !a[:data_inicio].blank? }
end