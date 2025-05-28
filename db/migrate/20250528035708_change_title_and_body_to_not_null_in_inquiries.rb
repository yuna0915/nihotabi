class ChangeTitleAndBodyToNotNullInInquiries < ActiveRecord::Migration[6.1]
  def change
    change_column_null :inquiries, :title, false
    change_column_null :inquiries, :body, false
  end
end
