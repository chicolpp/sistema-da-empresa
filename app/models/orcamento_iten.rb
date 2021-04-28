class OrcamentoIten < ActiveRecord::Base
  audited
  
  belongs_to :orcamento
end