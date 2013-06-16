class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table :image_attachments do |t|
      t.references :association, polymorphic: true
      t.timestamps
    end
    add_column :image_attachments, :image_file_name, :string
    add_column :image_attachments, :image_content_type, :string
    add_column :image_attachments, :image_file_size, :string
    add_column :image_attachments, :image_updated_at, :string

    add_index :image_attachments, :association_id
    add_index :image_attachments, :association_type
  end
end
