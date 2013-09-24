class AddPriceAdjustedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :adjusted_price, :integer
  end
end
