class CreatePessoasJuridicas < ActiveRecord::Migration
  def self.up
    create_table :pessoas_juridicas do |t|
      t.string :razao_social
      t.string :cnpj
      t.string :ie
      t.string :im
      t.date :data_fundacao
      t.references :pessoa, null: false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pessoas_juridicas
  end
end