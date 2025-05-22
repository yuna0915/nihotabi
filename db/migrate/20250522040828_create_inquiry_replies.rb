class CreateInquiryReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_replies do |t|
      t.references :inquiry, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
