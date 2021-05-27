class AddUuidForSync < ActiveRecord::Migration
  def change
    add_column :pessoas,  :uuid, :string
    add_column :produtos, :uuid, :string
    add_column :servicos, :uuid, :string
  end
end
