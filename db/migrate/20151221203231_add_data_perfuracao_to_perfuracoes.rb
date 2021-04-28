class AddDataPerfuracaoToPerfuracoes < ActiveRecord::Migration
  def change
    remove_column :perfuracoes, :data_perfuracao
    add_column :perfuracoes, :data_perfuracao_inicio, :date
    add_column :perfuracoes, :data_perfuracao_fim, :date
  end
end
