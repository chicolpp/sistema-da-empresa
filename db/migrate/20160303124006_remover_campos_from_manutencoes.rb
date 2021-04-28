class RemoverCamposFromManutencoes < ActiveRecord::Migration
  def change
  	remove_column :manutencaos, :data_iniciada
  	remove_column :manutencaos, :data_final
  	remove_column :manutencaos, :contato
  	remove_column :manutencaos, :telefone
  	remove_column :manutencaos, :email
  end
end
