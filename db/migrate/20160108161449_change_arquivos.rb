class ChangeArquivos < ActiveRecord::Migration
  def change
    remove_column :arquivos, :vazao_agua_id
    remove_column :arquivos, :instalacao_id
    add_column :arquivos, :owner_id, :integer
    add_column :arquivos, :owner_type, :string
  end
end
