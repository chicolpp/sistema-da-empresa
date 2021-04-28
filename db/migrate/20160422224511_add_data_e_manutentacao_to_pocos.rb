class AddDataEManutentacaoToPocos < ActiveRecord::Migration
  def change
    add_column :pocos, :data_instalacao, :date
    add_column :pocos, :periodo_manutencao, :integer
  end
end