class AddProfundidadeToPoco < ActiveRecord::Migration
  def change
  	add_column :pocos, :profundidade, :string
  end
end