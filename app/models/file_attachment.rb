class FileAttachment < ActiveRecord::Base
  attr_accessible :association_type, :association_id, :file, :short_summary
  before_create :update_file_attributes

  mount_uploader :file, FileUploader
  belongs_to :association, polymorphic: true

  def to_param
    "#{id}-#{File.basename(file.to_s)}"
  end

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end
end
