class FileAttachment < ActiveRecord::Base
  attr_accessible :association_type, :association_id, :file, :short_summary

  mount_uploader :file, FileUploader
  belongs_to :association, polymorphic: true

end
