class CreatePessoasClassificacoes < ActiveRecord::Migration
  def self.up
    create_table :pessoas_classificacoes do |t|
      t.integer :classificacao
      t.references :pessoa, null: false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_classificacoes
  end
end