class ChangeIsCheckedToNotNullInInquiries < ActiveRecord::Migration[6.1]
  def change
    change_column_null :inquiries, :is_checked, false
  end
end
