class ManutencaoFuncionario < ActiveRecord::Base
  audited
  
  belongs_to :manutencao_servico
  belongs_to :funcionario

  validates :funcionario_id, presence: true
end