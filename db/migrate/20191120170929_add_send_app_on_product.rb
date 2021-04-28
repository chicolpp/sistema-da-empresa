class AddSendAppOnProduct < ActiveRecord::Migration
  def change
    add_column :produtos, :exibir_app, :boolean
  end
end
