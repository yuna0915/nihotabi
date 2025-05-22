class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :body
      t.boolean :is_checked

      t.timestamps
    end
  end
end
