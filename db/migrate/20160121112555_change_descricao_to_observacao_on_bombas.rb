class ChangeDescricaoToObservacaoOnBombas < ActiveRecord::Migration
  def change
    rename_column :bombas, :descricao, :observacao
  end
end
