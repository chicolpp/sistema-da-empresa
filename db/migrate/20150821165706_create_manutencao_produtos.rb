class CreateManutencaoProdutos < ActiveRecord::Migration
  def self.up
    create_table :manutencao_produtos do |t|
      t.integer :manutencao_id
      t.integer :produto_id
      t.string :quantidade
      t.string :observacao
      t.timestamps
    end
  end

  def self.down
    drop_table :manutencao_produtos
  end
end