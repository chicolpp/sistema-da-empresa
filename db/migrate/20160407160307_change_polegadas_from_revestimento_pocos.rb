class ChangePolegadasFromRevestimentoPocos < ActiveRecord::Migration
  def change
  	change_column :revestimento_pocos, :polegadas, :string
  end
end
