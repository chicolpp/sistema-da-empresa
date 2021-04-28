class AddDataTesteToVazoesAgua < ActiveRecord::Migration
  def change
    add_column :vazoes_agua, :data_teste, :date
  end
end
