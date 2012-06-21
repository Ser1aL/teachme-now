class CreateUserRegistrations < ActiveRecord::Migration
  def change
    create_table :user_registrations do |t|
      t.integer :user_id
      t.string :provider
      t.string :hash_token
      t.string :provider_url
      t.string :provider_user_id

      t.timestamps
    end

    add_index :user_registrations, :user_id
  end
end
