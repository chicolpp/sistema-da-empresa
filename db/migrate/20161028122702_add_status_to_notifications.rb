class AddStatusToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :status, :boolean
  end
end
