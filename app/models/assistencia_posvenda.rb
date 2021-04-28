class AssistenciaPosvenda < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :admin_user, class_name: "Casein::AdminUser"

  validates :cliente_id, :admin_user_id, presence: true
end