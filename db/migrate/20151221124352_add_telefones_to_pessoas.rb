class AddTelefonesToPessoas < ActiveRecord::Migration
  def change
    add_column :pessoas, :telefone_principal, :string
  end
end
