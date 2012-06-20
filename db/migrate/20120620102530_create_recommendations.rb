class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :lesson_id
      t.integer :author_id
      t.text :text

      t.timestamps
    end

    add_index :recommendations, :lesson_id
    add_index :recommendations, :author_id
  end
end
