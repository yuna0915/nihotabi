class ChangeTermsContentToNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :terms, :content, false
  end
end
