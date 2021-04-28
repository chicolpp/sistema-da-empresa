class AddVendedorIdToManutencoes < ActiveRecord::Migration
  def change
  	add_column :manutencaos, :vendedor_id, :integer
  end
end
