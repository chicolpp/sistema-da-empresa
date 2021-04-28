class AddDadosToManutencaoServicos < ActiveRecord::Migration
  def change
  	add_column :manutencao_servicos, :tipo, :integer
  	add_column :manutencao_servicos, :descricao, :string
  	add_column :manutencao_servicos, :data_servico, :date
  	add_column :manutencao_servicos, :pessoa_contato, :string
  	add_column :manutencao_servicos, :telefone, :string
  	add_column :manutencao_servicos, :email, :string
  end
end