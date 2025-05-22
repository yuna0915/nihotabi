class CreateTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :terms do |t|
      t.text :content

      t.timestamps
    end
  end
end
