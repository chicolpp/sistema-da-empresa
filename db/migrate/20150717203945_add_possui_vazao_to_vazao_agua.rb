class AddPossuiVazaoToVazaoAgua < ActiveRecord::Migration
  def change
  	add_column :vazoes_agua, :possui_vazao, :boolean, default: true
  end
end
