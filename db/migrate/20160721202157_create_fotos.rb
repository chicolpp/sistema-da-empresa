class CreateFotos < ActiveRecord::Migration
  def self.up
    create_table :fotos do |t|
      t.integer :casein_admin_user_id
      t.integer :cliente_id
      t.attachment :foto
      t.string :observacao
      t.integer :status, default: 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :fotos
  end
end