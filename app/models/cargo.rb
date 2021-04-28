class Cargo < ActiveRecord::Base
  audited
  
  has_many :funcionarios
  
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }

  scope :id, -> id { where(id: id) }
end
