require "open-uri"

class ImageAttachment < ActiveRecord::Base
  attr_accessible :association_id, :association_type, :image
  mount_uploader :image, ImageUploader
  belongs_to :association, polymorphic: true

  def self.image_from_url(url, basename)
    extname = File.extname(url)
    image_file = Tempfile.new([basename, extname])
    image_file.binmode
    image_file.write open(URI::escape(url)).read
    image_file.rewind
    image_file
  end
end
