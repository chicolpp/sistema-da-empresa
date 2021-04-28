class CreateEnergias < ActiveRecord::Migration
  def self.up
    create_table :energias do |t|
      t.text :descricao

      t.timestamps
    end
  end

  def self.down
    drop_table :energias
  end
end
