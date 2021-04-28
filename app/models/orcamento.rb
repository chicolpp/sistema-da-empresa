class Orcamento < ActiveRecord::Base
  audited
  
  belongs_to :cliente
  belongs_to :casein_admin_user, :class_name => "Casein::AdminUser"
  has_many :orcamento_itens, dependent: :destroy

  accepts_nested_attributes_for :orcamento_itens, :reject_if => :all_blank, :allow_destroy => true
  
  scope :cliente_id, -> cliente_id { where(cliente_id: cliente_id) }
end