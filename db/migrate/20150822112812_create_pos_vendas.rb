class CreatePosVendas < ActiveRecord::Migration
  def self.up
    create_table :pos_vendas do |t|
      t.integer :cliente_id
      t.string :resposta1
      t.string :resposta2
      t.string :resposta3
      t.string :resposta4
      t.string :resposta5
      t.string :resposta6
      t.string :resposta7
      t.string :resposta8
      t.string :resposta9
      t.string :resposta10
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pos_vendas
  end
end