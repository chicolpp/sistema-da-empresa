class AddDadosToManutencaos < ActiveRecord::Migration
  def change
  	remove_column :manutencaos, :descricao_servico
  	remove_column :manutencao_servicos, :pessoa_contato
  	remove_column :manutencao_servicos, :telefone
  	remove_column :manutencao_servicos, :email
  	remove_column :manutencao_servicos, :servico_id
  	add_column :manutencaos, :pessoa_contato, :string
  	add_column :manutencaos, :telefone, :string
  	add_column :manutencaos, :email, :string
  	add_column :manutencaos, :servico_id, :integer
  end
end