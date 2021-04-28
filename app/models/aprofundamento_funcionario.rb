class AprofundamentoFuncionario < ActiveRecord::Base
  audited
  
  belongs_to :aprofundamento
  belongs_to :funcionario
end