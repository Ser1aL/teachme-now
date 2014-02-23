class AddAdjustmentStrategyToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :adjustment_used, :boolean, default: true
  end
end
