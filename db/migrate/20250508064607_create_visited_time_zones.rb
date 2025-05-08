class CreateVisitedTimeZones < ActiveRecord::Migration[6.1]
  def change
    create_table :visited_time_zones do |t|
      t.string :hour, null: false

      t.timestamps
    end
  end
end
