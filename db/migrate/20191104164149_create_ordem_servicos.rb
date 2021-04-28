class CreateOrdemServicos < ActiveRecord::Migration
  def change
    create_table :ordem_servicos do |t|
      t.date :abertura
      t.integer :status
      t.text :observacoes

      t.references :poco, index:true, foreign_key: {to_table: :pocos}
      t.references :funcionario, index:true, foreign_key: {to_table: :funcionarios}

      t.timestamps null: false
    end
  end
end
