# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120621085656) do

  create_table "courses", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "sub_interest_id"
    t.integer  "owner_id"
    t.string   "name"
    t.string   "city"
    t.text     "description"
    t.text     "tease_descriptions"
    t.integer  "times_per_week"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "courses", ["interest_id"], :name => "index_courses_on_interest_id"
  add_index "courses", ["owner_id"], :name => "index_courses_on_owner_id"
  add_index "courses", ["sub_interest_id"], :name => "index_courses_on_sub_interest_id"

  create_table "image_attachments", :force => true do |t|
    t.integer  "association_id"
    t.string   "association_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "image_attachments", ["association_id"], :name => "index_image_attachments_on_association_id"
  add_index "image_attachments", ["association_type"], :name => "index_image_attachments_on_association_type"

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lesson_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lesson_subscriptions", ["lesson_id"], :name => "index_lesson_subscriptions_on_lesson_id"
  add_index "lesson_subscriptions", ["user_id"], :name => "index_lesson_subscriptions_on_user_id"

  create_table "lessons", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "sub_interest_id"
    t.integer  "course_id"
    t.string   "name"
    t.string   "city"
    t.string   "level"
    t.integer  "duration"
    t.text     "description"
    t.text     "tease_description"
    t.integer  "capacity"
    t.integer  "places_taken",      :default => 0, :null => false
    t.integer  "place_price"
    t.datetime "start_datetime"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "lessons", ["course_id"], :name => "index_lessons_on_course_id"
  add_index "lessons", ["interest_id"], :name => "index_lessons_on_interest_id"
  add_index "lessons", ["sub_interest_id"], :name => "index_lessons_on_sub_interest_id"

  create_table "ratings", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "student_id"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ratings", ["student_id"], :name => "index_ratings_on_student_id"
  add_index "ratings", ["teacher_id"], :name => "index_ratings_on_teacher_id"

  create_table "recommendations", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "author_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommendations", ["author_id"], :name => "index_recommendations_on_author_id"
  add_index "recommendations", ["lesson_id"], :name => "index_recommendations_on_lesson_id"

  create_table "shares", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.string   "share_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "shares", ["lesson_id"], :name => "index_shares_on_lesson_id"
  add_index "shares", ["user_id"], :name => "index_shares_on_user_id"

  create_table "skills", :force => true do |t|
    t.integer  "sub_interest_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "skills", ["sub_interest_id"], :name => "index_skills_on_sub_interest_id"
  add_index "skills", ["user_id"], :name => "index_skills_on_user_id"

  create_table "sub_interests", :force => true do |t|
    t.integer  "interest_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sub_interests", ["interest_id"], :name => "index_sub_interests_on_interest_id"

  create_table "user_connections", :force => true do |t|
    t.integer  "leader_id"
    t.integer  "follower_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_connections", ["follower_id"], :name => "index_user_connections_on_follower_id"
  add_index "user_connections", ["leader_id"], :name => "index_user_connections_on_leader_id"

  create_table "user_registrations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "hash_token"
    t.string   "provider_url"
    t.string   "provider_user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "user_registrations", ["user_id"], :name => "index_user_registrations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "send_emails"
    t.string   "sex"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
