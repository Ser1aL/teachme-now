class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :lesson_id
      t.integer :user_id
      t.string :share_type

      t.timestamps
    end
    add_index :shares, :lesson_id
    add_index :shares, :user_id
  end
end
