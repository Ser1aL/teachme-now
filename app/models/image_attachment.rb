class ImageAttachment < ActiveRecord::Base
  attr_accessible :association_id, :association_type

  belongs_to :association, polymorphic: true

  has_attached_file :image, styles: { :medium => "300x300>", :thumb => "100x100>" }

end
