class RemoveCourses < ActiveRecord::Migration
  def up
    drop_table :courses
    remove_column :lessons, :course_id
    rename_column :comments, :commentable_id, :lesson_id
    remove_column :comments, :commentable_type
    rename_index :comments,
      'index_comments_on_commentable_id_and_commentable_type',
      'index_comments_on_lesson_id'
  end

  def down
    create_table "courses", force: true do |t|
      t.integer  "interest_id"
      t.integer  "sub_interest_id"
      t.integer  "owner_id"
      t.string   "name"
      t.string   "city"
      t.text     "description"
      t.integer  "times_per_week"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "allow_split_buy",  default: true
      t.boolean  "changeable_price", default: false
    end
    add_column :lessons, :course_id, :integer
    rename_column :comments, :lesson_id, :commentable_id
    add_column :comments, :commentable_type, :string, default: 'Lesson'

    rename_index :comments,
      'index_comments_on_lesson_id',
      'index_comments_on_commentable_id_and_commentable_type'
  end
end
