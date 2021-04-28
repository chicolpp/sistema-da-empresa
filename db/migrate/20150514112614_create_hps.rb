class CreateHps < ActiveRecord::Migration
  def self.up
    create_table :hps do |t|
      t.text :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :hps
  end
end