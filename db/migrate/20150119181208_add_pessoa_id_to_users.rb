class AddPessoaIdToUsers < ActiveRecord::Migration
  def change
  	add_column :casein_admin_users, :pessoa_id, :integer
  end
end
