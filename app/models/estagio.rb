class Estagio < ActiveRecord::Base
  audited
  
  has_many :bombas

  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }
end
