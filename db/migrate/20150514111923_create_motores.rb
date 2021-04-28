class CreateMotores < ActiveRecord::Migration
  def self.up
    create_table :motores do |t|
      t.text :descricao

      t.timestamps
    end
  end

  def self.down
    drop_table :motores
  end
end
