class AddSintomaOrder < ActiveRecord::Migration
  def change
    add_column :ordem_servicos, :sintoma, :text
  end
end
