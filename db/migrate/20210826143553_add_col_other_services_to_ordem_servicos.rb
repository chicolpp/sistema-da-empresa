class AddColOtherServicesToOrdemServicos < ActiveRecord::Migration
  def change
    add_column :ordem_servicos, :other_services, :text
    add_column :arquivos, :uuid, :string
  end
end
