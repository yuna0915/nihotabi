class ChangePrefectureIdToNotNullInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :prefecture_id, false
  end
end
