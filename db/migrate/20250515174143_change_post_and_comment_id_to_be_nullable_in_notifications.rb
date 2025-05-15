class ChangePostAndCommentIdToBeNullableInNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column_null :notifications, :post_id, true
    change_column_null :notifications, :comment_id, true
  end
end
