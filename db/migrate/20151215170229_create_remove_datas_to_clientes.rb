class CreateRemoveDatasToClientes < ActiveRecord::Migration
  def change
    remove_column :clientes, :data_inicio
    remove_column :clientes, :data_final
  end
end
