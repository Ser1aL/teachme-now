class AddEnabledToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :enabled, :boolean, default: false
  end
end
