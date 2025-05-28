class ChangeDefaultForIsCheckedInInquiries < ActiveRecord::Migration[6.1]
  def change
    change_column_default :inquiries, :is_checked, from: nil, to: false
  end
end
