class Bitola < ActiveRecord::Base
  audited
  
  has_many :perfuracoes
  has_many :revestimento_pocos_bitola
  has_many :aprofundamento

  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }
end
