class AddObservacaoToPocos < ActiveRecord::Migration
  def change
    add_column :pocos, :observacao, :text
  end
end
