class AddPeriodoManutencaoOnPoco < ActiveRecord::Migration
  def change
    add_column :pocos, :periodo_manutencao, :integer
  end
end
