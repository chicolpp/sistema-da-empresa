class AddDefaultToUserAppsActive < ActiveRecord::Migration
  def change
    change_column :user_apps, :active, :boolean, :default => false
  end
end
