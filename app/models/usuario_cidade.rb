class UsuarioCidade < ActiveRecord::Base
  audited
  
  belongs_to :cidade
  belongs_to :casein_admin_user
end