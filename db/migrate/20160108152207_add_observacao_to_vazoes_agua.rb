class AddObservacaoToVazoesAgua < ActiveRecord::Migration
  def change
    add_column :vazoes_agua, :observacao, :text
  end
end
