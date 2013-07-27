class AddContentTypeAndFileSizeToFileAttachments < ActiveRecord::Migration
  def change
    add_column :file_attachments, :content_type, :string
    add_column :file_attachments, :file_size, :string
  end
end
