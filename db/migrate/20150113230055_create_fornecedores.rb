class CreateFornecedores < ActiveRecord::Migration
  def self.up
    create_table :fornecedores do |t|
      t.references :pessoa, null: false
      t.string :nome_contato
      t.string :cargo
      t.text :observacoes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :fornecedores
  end
end