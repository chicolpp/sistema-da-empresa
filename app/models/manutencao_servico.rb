class ManutencaoServico < ActiveRecord::Base
  audited
  
  belongs_to :manutencao
  has_many :manutencao_funcionarios, dependent: :destroy
  accepts_nested_attributes_for :manutencao_funcionarios, :reject_if => :all_blank, :allow_destroy => true
  has_many :manutencao_servico_itens, dependent: :destroy
  accepts_nested_attributes_for :manutencao_servico_itens, :reject_if => :all_blank, :allow_destroy => true

  validates :tipo, :data_servico, presence: true
end