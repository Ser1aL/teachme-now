class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :sub_interest_id
      t.integer :user_id

      t.timestamps
    end

    add_index :sub_interest_id
    add_index :user_id
  end
end
