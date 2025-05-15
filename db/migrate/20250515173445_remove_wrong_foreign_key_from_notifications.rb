class RemoveWrongForeignKeyFromNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :notifications, column: :notified_user_id
  end
end
