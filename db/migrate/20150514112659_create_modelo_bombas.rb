class CreateModeloBombas < ActiveRecord::Migration
  def self.up
    create_table :modelo_bombas do |t|
      t.text :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :modelo_bombas
  end
end