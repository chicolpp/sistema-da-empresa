class AddColumnScheduleMaintenanceAtToPocos < ActiveRecord::Migration
  def change
    add_column :pocos, :schedule_maintenance_at, :date
    add_column :pocos, :lock_schedule_maintenance, :boolean
  end
end
