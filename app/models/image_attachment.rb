class ImageAttachment < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :image_association, polymorphic: true

  def self.image_from_url(url, basename)
    extname = File.extname(url)
    extname = '.jpg' if extname.blank?
    image_file = Tempfile.new([basename, extname])
    image_file.binmode

    touch_request = Net::HTTP.get_response(URI(URI::escape(url)))
    if touch_request.code == '302'
      image_file.write open(URI::escape(touch_request.header['location'])).read
    else
      image_file.write open(URI::escape(url)).read
    end

    image_file.rewind
    image_file
  end

  def to_param
    "#{id}-#{File.basename(image.to_s)}"
  end
end
