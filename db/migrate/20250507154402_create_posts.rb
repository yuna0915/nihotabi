class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :location_genre, null: false, foreign_key: true
      t.references :prefecture, null: false, foreign_key: true
      t.references :visited_month, null: false, foreign_key: true
      t.references :visited_hour, null: false, foreign_key: true

      t.string :title, null: false
      t.text :body, null: false
      t.string :location_name, null: false
      t.string :address, null: false
      t.string :place_id, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
