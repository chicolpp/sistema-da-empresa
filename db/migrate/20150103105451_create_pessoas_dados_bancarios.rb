class CreatePessoasDadosBancarios < ActiveRecord::Migration
  def self.up
    create_table :pessoas_dados_bancarios do |t|
      t.integer :nome_banco
      t.string :agencia
      t.string :conta
      t.references :pessoa, null: false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_dados_bancarios
  end
end