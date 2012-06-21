class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :sub_interest_id
      t.integer :user_id

      t.timestamps
    end

    add_index :skills, :sub_interest_id
    add_index :skills, :user_id
  end
end
