class PosVenda < ActiveRecord::Base
  audited
  
  belongs_to :cliente

  validates :cliente_id, presence: true

  scope :cliente_id, -> cliente_id { where(cliente_id: cliente_id) }
end