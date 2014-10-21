class AddLessonsPermanentPublishDuration < ActiveRecord::Migration
  def change
    add_column :lessons, :permanent, :boolean, default: false
    add_column :lessons, :publish_duration, :datetime
  end
end
