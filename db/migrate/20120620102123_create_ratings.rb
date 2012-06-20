class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.integer :rating

      t.timestamps
    end
    add_index :ratings, :teacher_id
    add_index :ratings, :student_id
  end
end
