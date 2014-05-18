# require "open-uri"
class ImageAttachment < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :image_association, polymorphic: true

  def self.image_from_url(url, basename)
    extname = File.extname(url)
    extname = '.jpg' if extname.blank?
    image_file = Tempfile.new([basename, extname])
    image_file.binmode
    image_file.write open(URI::escape(url)).read
    image_file.rewind
    image_file
  end

  def to_param
    "#{id}-#{File.basename(image.to_s)}"
  end
end
