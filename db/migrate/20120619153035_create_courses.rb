class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :interest_id
      t.integer :sub_interest_id
      t.integer :owner_id
      t.string :name
      t.string :city
      t.text :description
      t.text :tease_description
      t.integer :times_per_week

      t.timestamps
    end

    add_index :courses, :interest_id
    add_index :courses, :sub_interest_id
    add_index :courses, :owner_id
  end
end
