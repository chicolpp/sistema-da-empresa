class CreateInstalacaoProdutos < ActiveRecord::Migration
  def self.up
    create_table :instalacao_produtos do |t|
      t.integer :instalacao_id
      t.integer :produto_id
      t.integer :quantidade
      t.string :observacao
      
      t.timestamps
    end
  end

  def self.down
    drop_table :instalacao_produtos
  end
end