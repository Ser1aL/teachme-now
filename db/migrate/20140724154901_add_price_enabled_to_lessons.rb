class AddPriceEnabledToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :sale_enabled, :boolean, default: false
  end
end
