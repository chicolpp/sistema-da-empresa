class ChangeInstalacaoProdutosToPocoEquipamentos < ActiveRecord::Migration
  def change
  	rename_table :instalacao_produtos, :instalacao_poco_equipamentos
  end
end