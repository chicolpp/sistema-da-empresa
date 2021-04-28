class CreateAlertas < ActiveRecord::Migration
  def self.up
    create_table :alertas do |t|
      t.text :descricao
      t.datetime :exibir_ate
      
      t.timestamps
    end
  end

  def self.down
    drop_table :alertas
  end
end