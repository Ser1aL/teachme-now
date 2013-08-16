class CreateMessageNotifications < ActiveRecord::Migration
  def change
    create_table :message_notifications do |t|
      t.references :user
      t.references :comment
      t.boolean :is_read, default: false, null: false
      t.timestamps
    end
    add_index :message_notifications, :user_id
    add_index :message_notifications, :comment_id
  end
end
