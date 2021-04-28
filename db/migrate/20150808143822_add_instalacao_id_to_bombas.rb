class AddInstalacaoIdToBombas < ActiveRecord::Migration
  def change
  	add_column :bombas, :instalacao_id, :integer
  end
end
