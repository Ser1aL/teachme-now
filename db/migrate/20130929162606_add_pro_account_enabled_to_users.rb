class AddProAccountEnabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pro_account_enabled, :boolean, default: false
  end
end
