class AddTelefonesToPessoasFisicas < ActiveRecord::Migration
  def change
    add_column :pessoas_fisicas, :telefone_auxiliar_1, :string
    add_column :pessoas_fisicas, :telefone_auxiliar_2, :string
    add_column :pessoas_fisicas, :telefone_auxiliar_3, :string
  end
end
