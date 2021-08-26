class AddExibeAppOnServicos < ActiveRecord::Migration
  def change
    add_column :servicos, :exibe_app, :boolean, default: false
  end
end
