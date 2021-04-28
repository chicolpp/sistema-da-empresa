class CreateEstagios < ActiveRecord::Migration
  def self.up
    create_table :estagios do |t|
      t.text :descricao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :estagios
  end
end