class AddNomeToFotos < ActiveRecord::Migration
  def change
    add_column :fotos, :nome, :string
  end
end
