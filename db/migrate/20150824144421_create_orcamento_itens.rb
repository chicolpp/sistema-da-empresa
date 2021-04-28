class CreateOrcamentoItens < ActiveRecord::Migration
  def self.up
    create_table :orcamento_itens do |t|
      t.integer :orcamento_id
      t.string :quantidade
      t.string :descricao
      t.string :preco_unitario
      t.string :preco_total
      t.string :unidade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orcamento_itens
  end
end