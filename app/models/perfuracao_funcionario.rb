class PerfuracaoFuncionario < ActiveRecord::Base
  audited
  
  belongs_to :perfuracao
  belongs_to :funcionario

  validates :funcionario_id, presence: true
end
