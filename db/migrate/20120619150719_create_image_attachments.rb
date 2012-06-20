class CreateImageAttachments < ActiveRecord::Migration
  def change
    create_table :image_attachments do |t|
      t.references :association, polymorphic: true
      t.timestamps
    end
    add_attachment :image_attachments, :image
    add_index :image_attachments, :association_id
    add_index :image_attachments, :association_type
  end
end
