class AddLessonsPermanentPublishDuration < ActiveRecord::Migration
  def change
    add_column :lessons, :permanent, :boolean, default: false
    add_column :lessons, :publish_duration, :integer, default: 0
  end
end
