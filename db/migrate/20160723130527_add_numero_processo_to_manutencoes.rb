class AddNumeroProcessoToManutencoes < ActiveRecord::Migration
  def change
  	add_column :manutencaos, :numero_processo, :string
  end
end
