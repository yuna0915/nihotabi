class AddCorrectForeignKeyToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :notifications, :users, column: :notified_user_id
  end
end
