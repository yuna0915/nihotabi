class AddNotNullToActionInNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column_null :notifications, :action, false
  end
end
