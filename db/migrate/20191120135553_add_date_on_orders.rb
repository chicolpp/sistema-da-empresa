class AddDateOnOrders < ActiveRecord::Migration
  def change
    add_column :ordem_servicos, :data_servico_realizado, :date
    add_column :ordem_servicos, :data_proxima_etapa, :date
  end
end
