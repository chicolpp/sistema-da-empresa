class CreateMaquinas < ActiveRecord::Migration
  def self.up
    create_table :maquinas do |t|
      t.string :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :maquinas
  end
end