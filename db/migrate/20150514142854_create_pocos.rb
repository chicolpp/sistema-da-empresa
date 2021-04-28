class CreatePocos < ActiveRecord::Migration
  def self.up
    create_table :pocos do |t|
      t.boolean :poco_produtivo
      t.integer :cliente_id
      t.string :linha_endereco
      t.string :apelido_endereco
      t.boolean :perfuracao_leao
      t.integer :cidade_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pocos
  end
end
