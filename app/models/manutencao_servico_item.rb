class ManutencaoServicoItem < ActiveRecord::Base
  audited
  
  belongs_to :manutencao_servico
  belongs_to :produto

  validates :quantidade, :produto_id, presence: true
end