class CreatePessoasContatos < ActiveRecord::Migration
  def self.up
    create_table :pessoas_contatos do |t|
      t.integer :tipo_contato
      t.string :valor
      t.references :pessoa, null: false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_contatos
  end
end