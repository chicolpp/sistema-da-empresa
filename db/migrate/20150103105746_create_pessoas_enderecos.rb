class CreatePessoasEnderecos < ActiveRecord::Migration
  def self.up
    create_table :pessoas_enderecos do |t|
      t.integer :tipo_endereco
      t.string :cep
      t.string :endereco
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.integer :cidade_id
      t.integer :cidade_natal_id
      t.references :pessoa, null: false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_enderecos
  end
end