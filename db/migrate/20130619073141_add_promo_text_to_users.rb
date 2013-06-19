class AddPromoTextToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promo_text, :text

    remove_column :courses, :tease_description
    remove_column :lessons, :tease_description
  end
end
