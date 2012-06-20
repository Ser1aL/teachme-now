class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.integer :leader_id
      t.integer :follower_id

      t.timestamps
    end
    add_index :user_connections, :leader_id
    add_index :user_connections, :follower_id
  end
end
