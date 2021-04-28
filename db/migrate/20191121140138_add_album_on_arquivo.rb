class AddAlbumOnArquivo < ActiveRecord::Migration
  def change
    add_column :arquivos, :album, :string
  end
end
