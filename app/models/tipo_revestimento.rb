class TipoRevestimento < ActiveRecord::Base
  audited
  
  validates :descricao, presence: true
  validates :descricao, length: { maximum: 250 }
end