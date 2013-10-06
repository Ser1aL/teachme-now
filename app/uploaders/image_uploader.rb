# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/images/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
     # For Rails 3.1+ asset pipeline compatibility:
     asset_path([version_name, "missing.jpg"].compact.join('_'))
  end

  # Create different versions of your uploaded files:
  version :thumb do
     process :resize_to_fill => [100, 100]
  end

  version :medium do
     process :resize_to_fill => [140, 157]
  end

  version :preview do
    process :resize_to_fill => [184, 184]
  end

  version :gallery do
     process :resize_to_fill => [470, 300]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     ['jpg', 'jpeg', 'png', 'gif']
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
