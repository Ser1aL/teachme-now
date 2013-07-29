class SplitLessonDescription < ActiveRecord::Migration
  def up
    rename_column :lessons, :description, :description_top
    add_column :lessons, :description_bottom, :text
  end

  def down
    rename_column :lessons, :description_top, :description
    remove_column :lessons, :description_bottom
  end
end
