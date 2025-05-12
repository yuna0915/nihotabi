class AddIsActiveToMasterData < ActiveRecord::Migration[6.1]
  def change
    add_column :prefectures, :is_active, :boolean, default: true, null: false
    add_column :visited_months, :is_active, :boolean, default: true, null: false
    add_column :visited_time_zones, :is_active, :boolean, default: true, null: false
    add_column :location_genres, :is_active, :boolean, default: true, null: false
  end
end
