class AddColOtherServicesToOrdemServicos < ActiveRecord::Migration
  def change
    add_column :ordem_servicos, :other_services, :text
  end
end
