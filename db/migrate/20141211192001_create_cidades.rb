class CreateCidades < ActiveRecord::Migration
  def self.up
    create_table :cidades do |t|
      t.string   :nome,                :null => false
      t.integer  :estado_id,           :null => false
    end
  end

  def self.down
    drop_table :cidades
  end
end