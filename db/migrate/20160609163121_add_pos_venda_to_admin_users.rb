class AddPosVendaToAdminUsers < ActiveRecord::Migration
  def change
  	add_column :casein_admin_users, :pos_venda, :boolean
  end
end