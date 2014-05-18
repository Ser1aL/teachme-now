class FileAttachment < ActiveRecord::Base
  before_create :update_file_attributes

  mount_uploader :file, FileUploader
  belongs_to :file_association, polymorphic: true

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
