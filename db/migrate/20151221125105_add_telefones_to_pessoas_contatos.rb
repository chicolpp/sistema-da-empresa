class AddTelefonesToPessoasContatos < ActiveRecord::Migration
  def change
    add_column :pessoas_contatos, :telefone_contato, :string
  end
end
