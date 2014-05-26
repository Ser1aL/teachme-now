class AddSplitBuyStablePriceToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :allow_split_buy, :boolean, default: true
    add_column :courses, :changeable_price, :boolean, default: false
  end
end
