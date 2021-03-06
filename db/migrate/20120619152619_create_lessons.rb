class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :interest_id
      t.integer :sub_interest_id
      t.integer :course_id
      t.string :name
      t.string :city
      t.string :address_line
      t.string :level
      t.integer :duration
      t.text :description
      t.text :tease_description
      t.integer :capacity
      t.integer :places_taken, default: 0, null: false
      t.integer :place_price
      t.datetime :start_datetime

      t.timestamps
    end

    add_index :lessons, :interest_id
    add_index :lessons, :sub_interest_id
    add_index :lessons, :course_id
  end
end
