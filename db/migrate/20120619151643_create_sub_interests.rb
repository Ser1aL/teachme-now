class CreateSubInterests < ActiveRecord::Migration
  def change
    create_table :sub_interests do |t|
      t.integer :interest_id
      t.text :description

      t.timestamps
    end
    add_index :sub_interests, :interest_id
  end
end
