class AddPolegadasToRevestimentos < ActiveRecord::Migration
  def change
  	add_column :revestimento_pocos, :polegadas, :integer
  end
end
