class ChangeManutencaoServicoToManutencaoFuncionarios < ActiveRecord::Migration
  def change
  	remove_column :manutencao_funcionarios, :manutencao_id
  	add_column :manutencao_funcionarios, :manutencao_servico_id, :integer
  end
end