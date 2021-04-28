class CreateUsuarioCidades < ActiveRecord::Migration
  def self.up
    create_table :usuario_cidades do |t|
      t.integer :cidade_id
      t.integer :admin_user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :usuario_cidades
  end
end