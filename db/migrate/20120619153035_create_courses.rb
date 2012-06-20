class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :owner_id
      t.string :name
      t.string :city
      t.text :description
      t.text :tease_descriptions
      t.integer :times_per_week

      t.timestamps
    end

    add_index :courses, :owner_id
  end
end
