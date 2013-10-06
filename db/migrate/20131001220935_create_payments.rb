class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :vendor
      t.string :vendor_token
      t.string :contact_phone
      t.integer :amount
      t.string :currency
      t.string :referenced
      t.text :raw_response

      t.timestamps
    end
  end
end
