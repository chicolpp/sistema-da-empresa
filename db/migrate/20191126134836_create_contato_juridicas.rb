class CreateContatoJuridicas < ActiveRecord::Migration
  def change
    create_table :contato_juridicas do |t|
      t.string :nome_completo
      t.string :telefone
      t.date :data_de_nascimento

      t.references :pessoa_juridica, index:true, foreign_key: {to_table: :pessoas_juridicas}

      t.timestamps
    end
  end
end
