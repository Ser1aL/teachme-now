class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :giver_id
      t.integer :taker_id
      t.integer :rating

      t.timestamps
    end
    add_index :ratings, :giver_id
    add_index :ratings, :taker_id
  end
end
