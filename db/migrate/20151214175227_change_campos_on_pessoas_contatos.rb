class ChangeCamposOnPessoasContatos < ActiveRecord::Migration
  def change
    remove_column :pessoas_contatos, :valor
    remove_column :pessoas_contatos, :tipo_contato
    add_column :pessoas_contatos, :nome_contato, :string
    add_column :pessoas_contatos, :email_contato, :string
    add_column :pessoas_contatos, :data_nascimento_contato, :date
  end
end
