class RevestimentoPoco < ActiveRecord::Base
  audited
  
  belongs_to :poco
  belongs_to :tipo_revestimento
  has_many :revestimento_pocos_bitola

  validates :tipo_revestimento_id, :polegadas, :quantidade, presence: true
end