class InstalacaoFuncionario < ActiveRecord::Base
  audited
  
  belongs_to :instalacao
  belongs_to :funcionario

	validates :funcionario_id, presence: true
end