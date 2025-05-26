class UpdatePostForeignKeysToCascadeDelete < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :comments, :posts
    add_foreign_key :comments, :posts, on_delete: :cascade

    remove_foreign_key :favorites, :posts
    add_foreign_key :favorites, :posts, on_delete: :cascade
  end
end
