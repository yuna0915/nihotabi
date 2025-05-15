class FixPostsForTextbook < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :place_id, :string

    change_column_default :posts, :address, from: nil, to: ""
    change_column_null :posts, :address, false

    change_column_default :posts, :latitude, from: nil, to: 0
    change_column_null :posts, :latitude, false

    change_column_default :posts, :longitude, from: nil, to: 0
    change_column_null :posts, :longitude, false
  end
end
