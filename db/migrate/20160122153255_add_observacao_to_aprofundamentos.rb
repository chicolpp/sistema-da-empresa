class AddObservacaoToAprofundamentos < ActiveRecord::Migration
  def change
    add_column :aprofundamentos, :observacao, :text
  end
end
