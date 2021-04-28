class ChangePeriodoManutencaoFromAll < ActiveRecord::Migration
  def change
  	remove_column :pocos, :periodo_manutencao
  	remove_column :pocos, :data_instalacao
  	add_column :instalacoes, :periodo_manutencao, :integer
  end
end