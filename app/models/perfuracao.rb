class Perfuracao < ActiveRecord::Base
  audited

  belongs_to :maquina
  belongs_to :bitola
  belongs_to :poco
  has_many :perfuracao_funcionarios, dependent: :destroy
  has_many :arquivos, dependent: :destroy, as: :owner

  accepts_nested_attributes_for :perfuracao_funcionarios, :allow_destroy => true

  validates :data_perfuracao_inicio, :data_perfuracao_fim, :profundidade, :maquina_id, :bitola_id, presence: true
end