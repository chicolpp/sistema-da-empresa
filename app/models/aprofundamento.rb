class Aprofundamento < ActiveRecord::Base
  audited
  
  belongs_to :poco
  belongs_to :maquina
  belongs_to :bitola
  has_one :vazao_agua, dependent: :destroy
  has_many :aprofundamento_funcionarios, dependent: :destroy
  has_many :entradas_agua, dependent: :destroy
  has_many :arquivos, dependent: :destroy, as: :owner

  accepts_nested_attributes_for :entradas_agua, :allow_destroy => true#, :reject_if => :all_blank
  accepts_nested_attributes_for :arquivos, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :aprofundamento_funcionarios, :allow_destroy => true

  #Escopos para filtros de busca
  scope :cliente_id, -> cliente_id { joins(:poco).where(pocos: { cliente_id: cliente_id }) }

  validates :poco_id, :data_inicio, :data_fim, :profundidade_nova, :maquina_id, :bitola_id, presence: true
end