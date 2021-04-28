class AddDataInstacao < ActiveRecord::Migration
  def change
    add_column :instalacoes, :data_instalacao_inicio, :date
  end
end
