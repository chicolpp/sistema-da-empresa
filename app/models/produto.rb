class Produto < ActiveRecord::Base
  audited
  
  belongs_to :unidade_medida
  has_many :instalacao_poco_equipamentos
  has_many :instalacao_adutora_equipamentos
  has_many :instalacao_distribuicao_equipamentos
  has_many :manutencao_produtos

  validates :descricao, uniqueness: true
  validates :descricao, length: { maximum: 250 }
  validates :descricao, :unidade_medida_id, presence: true
end