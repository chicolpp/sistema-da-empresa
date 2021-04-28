class AddCargoTelefone1Telefone2ToCaseinAdminUsers < ActiveRecord::Migration
  def change
  	add_column :casein_admin_users, :cargo, :string
  	add_column :casein_admin_users, :telefone1, :string
  	add_column :casein_admin_users, :telefone2, :string
  end
end
