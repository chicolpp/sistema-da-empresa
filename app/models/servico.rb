class Servico < ActiveRecord::Base
  audited
  
  has_many :manutencao_servicos
   
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }
end