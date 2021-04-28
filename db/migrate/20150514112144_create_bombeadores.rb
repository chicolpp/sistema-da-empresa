class CreateBombeadores < ActiveRecord::Migration
  def self.up
    create_table :bombeadores do |t|
      t.text :descricao

      t.timestamps
    end
  end

  def self.down
    drop_table :bombeadores
  end
end
