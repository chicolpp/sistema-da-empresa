class AddCidadeIdToCaseinAdminUsers < ActiveRecord::Migration
  def change
  	add_column :casein_admin_users, :cidade_id, :integer
  end
end
