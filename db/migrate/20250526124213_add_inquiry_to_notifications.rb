class AddInquiryToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :inquiry, foreign_key: true
  end
end
