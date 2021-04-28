class AddNumeroProcessoToPocos < ActiveRecord::Migration
  def change
    add_column :pocos, :numero_processo, :string
  end
end