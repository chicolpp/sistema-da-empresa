class ChangeDatasOnAprofundamentos < ActiveRecord::Migration
  def change
    rename_column :aprofundamentos, :data_aprofundamento, :data_inicio
    rename_column :aprofundamentos, :data_lancamento, :data_fim
  end
end
