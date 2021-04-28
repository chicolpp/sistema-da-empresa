class AddActiveToUserApps < ActiveRecord::Migration
  def change
    add_column :user_apps, :active, :boolean
  end
end
