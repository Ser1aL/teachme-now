class AddEnabledToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :enabled, :boolean, default: false
  end
end
