class ChangeInterestsAndSubinterests < ActiveRecord::Migration
  def up
    remove_column :interests, :description
    remove_column :sub_interests, :description

    add_column :interests, :translation, :string
    add_column :sub_interests, :translation, :string
  end

  def down
    add_column :interests, :description, :text
    add_column :sub_interests, :description, :text

    remove_column :interests, :translation
    remove_column :sub_interests, :translation
  end
end
