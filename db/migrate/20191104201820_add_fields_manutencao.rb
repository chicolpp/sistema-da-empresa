class AddFieldsManutencao < ActiveRecord::Migration
  def change
    add_column :arquivos, :nome, :string
    add_column :manutencaos, :ordem_servico_id, :integer
  end
end
