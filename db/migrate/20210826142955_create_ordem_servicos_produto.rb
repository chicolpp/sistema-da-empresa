class CreateOrdemServicosProduto < ActiveRecord::Migration
  def change
    create_table :ordem_servico_produtos do |t|
      t.references :ordem_servico, index:true, foreign_key: {to_table: :ordem_servicos}
      t.references :produto,       index:true, foreign_key: {to_table: :produtos}
      t.integer    :qtd, default: 1
      # t.boolean :todo

      t.timestamps
    end
  end
end
