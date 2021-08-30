class ChangeDataTypeForDescricaoToManutencaoServicos < ActiveRecord::Migration
  def change
    change_column :manutencao_servicos, :descricao, :text
  end
end