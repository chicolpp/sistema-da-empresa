class RemoveBombaIdToInstalacoes < ActiveRecord::Migration
  def change
  	remove_column :instalacoes, :bomba_id
  end
end
