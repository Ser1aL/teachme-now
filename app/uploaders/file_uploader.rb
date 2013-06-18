# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  storage :file
  def store_dir
    "uploads/files/#{model.id}"
  end

  def extension_white_list
     %w(xls doc docx txt)
  end

end
