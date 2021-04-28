class ChangeClienteIdToFotos < ActiveRecord::Migration
  def change
    add_column :fotos, :poco_id, :integer
    remove_column :fotos, :cliente_id
  end
end
