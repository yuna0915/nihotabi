class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notified_user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.string :action
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
