class AlteraCargoToFuncionario < ActiveRecord::Migration
  def change
    rename_column :funcionarios, :cargo, :cargo_id
  end
end
