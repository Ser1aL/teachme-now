class AddImageFieldToImageAttachments < ActiveRecord::Migration
  def change
    remove_column :image_attachments, :image_file_name
    remove_column :image_attachments, :image_content_type
    remove_column :image_attachments, :image_file_size
    remove_column :image_attachments, :image_updated_at

    add_column :image_attachments, :image, :string
  end
end
