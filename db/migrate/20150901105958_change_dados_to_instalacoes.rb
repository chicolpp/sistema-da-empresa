class ChangeDadosToInstalacoes < ActiveRecord::Migration
  def up
    change_column :instalacoes, :profundidade_bomba, :string
    change_column :instalacoes, :vazao_bomba, :string
    change_column :instalacoes, :nivel_dinamico, :string
    change_column :instalacoes, :perca_carga, :string
    change_column :instalacoes, :altura_nanometrica, :string
    change_column :instalacoes, :desnivel, :string
    change_column :instalacoes, :nivel_estatico, :string
    change_column :instalacoes, :distancia_poco_caixa, :string
  end
end
