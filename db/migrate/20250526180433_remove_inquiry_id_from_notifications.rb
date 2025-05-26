class RemoveInquiryIdFromNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :inquiry_id, :integer
  end
end
