class CreateBitolas < ActiveRecord::Migration
  def self.up
    create_table :bitolas do |t|
      t.string :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :bitolas
  end
end