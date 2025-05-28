class DropNotifiedUsers < ActiveRecord::Migration[6.1]
  def change
    drop_table :notified_users
  end
end
