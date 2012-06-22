class AddProvidersUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vkontakte_uid, :integer
    add_column :users, :facebook_uid, :integer
  end
end
