class RenameCheckedToIsCheckedInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :checked, :is_checked
  end
end
