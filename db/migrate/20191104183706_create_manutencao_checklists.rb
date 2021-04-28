class CreateManutencaoChecklists < ActiveRecord::Migration
  def change
    create_table :manutencao_checklists do |t|
      t.string :nome
      t.string :descricao
      t.string :observacoes
      t.integer :manutencao_id

      t.timestamps null: false
    end
  end
end
