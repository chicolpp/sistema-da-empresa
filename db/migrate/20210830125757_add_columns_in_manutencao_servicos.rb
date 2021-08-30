class AddColumnsInManutencaoServicos < ActiveRecord::Migration
  def change
    add_column :manutencao_servicos, :well_data,     :text # JSON Serialize
    add_column :manutencao_servicos, :service_items, :text # JSON Serialize
    add_column :manutencao_servicos, :well_acess,    :string
  end
end
