class AddProAccountDueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pro_account_due, :datetime
  end
end
