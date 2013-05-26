class AddIsPremiumToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :is_premium, :boolean
  end
end
