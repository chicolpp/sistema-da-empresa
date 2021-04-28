class VazaoAguaFuncionario < ActiveRecord::Base
  audited
  
  belongs_to :vazao_agua
  belongs_to :funcionario

  validates :funcionario_id, presence: true
end