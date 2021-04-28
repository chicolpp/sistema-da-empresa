class AddNomeFantasiaToPessoasJuridicas < ActiveRecord::Migration
  def change
    remove_column :pessoas_juridicas, :razao_social
  	add_column :pessoas_juridicas, :nome_fantasia, :string
  end
end
