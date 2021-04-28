class Marca < ActiveRecord::Base
  audited
  
  has_many :produtos 
  
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }
end