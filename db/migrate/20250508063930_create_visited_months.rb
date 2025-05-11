class CreateVisitedMonths < ActiveRecord::Migration[6.1]
  def change
    create_table :visited_months do |t|
      t.string :number, null: false

      t.timestamps
    end
  end
end
