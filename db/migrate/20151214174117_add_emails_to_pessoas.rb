class AddEmailsToPessoas < ActiveRecord::Migration
  def change
    add_column :pessoas, :email_contato, :string
    add_column :pessoas, :email_xml, :string
  end
end