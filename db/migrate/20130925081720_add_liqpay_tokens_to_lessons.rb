class AddLiqpayTokensToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :full_price_liqpay_token, :string
    add_column :lessons, :discount_price_liqpay_token, :string
  end
end
