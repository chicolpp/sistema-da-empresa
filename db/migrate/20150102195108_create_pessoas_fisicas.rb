class CreatePessoasFisicas < ActiveRecord::Migration
  def self.up
    create_table :pessoas_fisicas do |t|
      t.string :cpf
      t.string :rg
      t.date :data_nascimento
      t.integer :estado_civil
      t.boolean :sexo
      t.references :pessoa, null: false

      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_fisicas
  end
end
