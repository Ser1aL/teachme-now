class CreateFileAttachments < ActiveRecord::Migration
  def change
    create_table :file_attachments do |t|
      t.integer :association_id
      t.string :association_type
      t.string :file
      t.string :short_summary

      t.timestamps
    end
  end
end
