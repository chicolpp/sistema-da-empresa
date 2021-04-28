class AddProfundidadeBombaToVazoesAgua < ActiveRecord::Migration
  def change
  	add_column :vazoes_agua, :profundidade_bomba, :string
  end
end
