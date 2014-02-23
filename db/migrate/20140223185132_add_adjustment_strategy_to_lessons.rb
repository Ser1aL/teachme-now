class AddAdjustmentStrategyToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :adjustment_used, :boolean
  end
end
