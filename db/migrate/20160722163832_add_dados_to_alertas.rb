class AddDadosToAlertas < ActiveRecord::Migration
  def change
  	add_column :alertas, :titulo, :string
  end
end