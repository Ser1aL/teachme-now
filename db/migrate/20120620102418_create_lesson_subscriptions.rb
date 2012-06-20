class CreateLessonSubscriptions < ActiveRecord::Migration
  def change
    create_table :lesson_subscriptions do |t|
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end

    add_index :lesson_subscriptions, :user_id
    add_index :lesson_subscriptions, :lesson_id
  end
end
