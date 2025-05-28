class ChangeBodyToNotNullInInquiryReplies < ActiveRecord::Migration[6.1]
  def change
    change_column_null :inquiry_replies, :body, false
  end
end
