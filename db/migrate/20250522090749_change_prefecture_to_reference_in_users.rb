class ChangePrefectureToReferenceInUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :prefecture, :string

    add_reference :users, :prefecture, foreign_key: true
  end
end
