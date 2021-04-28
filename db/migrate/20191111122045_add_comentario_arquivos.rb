class AddComentarioArquivos < ActiveRecord::Migration
  def change
    add_column :arquivos, :comentarios, :text
  end
end
