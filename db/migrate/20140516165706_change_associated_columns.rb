class ChangeAssociatedColumns < ActiveRecord::Migration

  def up
    remove_index :image_attachments, :association_id
    remove_index :image_attachments, :association_type

    rename_column :image_attachments, :association_id, :image_association_id
    rename_column :image_attachments, :association_type, :image_association_type
    rename_column :file_attachments, :association_id, :file_association_id
    rename_column :file_attachments, :association_type, :file_association_type

    add_index :image_attachments, :image_association_id
    add_index :image_attachments, :image_association_type
    add_index :file_attachments, :file_association_id
    add_index :file_attachments, :file_association_type
  end

  def down
    remove_index :image_attachments, :image_association_id
    remove_index :image_attachments, :image_association_type
    remove_index :file_attachments, :file_association_id
    remove_index :file_attachments, :file_association_type

    rename_column :image_attachments, :image_association_id, :association_id
    rename_column :image_attachments, :image_association_type, :association_type
    rename_column :file_attachments, :file_association_id, :association_id
    rename_column :file_attachments, :file_association_type, :association_type

    add_index :image_attachments, :association_id
    add_index :image_attachments, :association_type
  end

end
