class ImageAttachmentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :remove_old_if_exists, only: :create
  respond_to :json

  def create
    params[:image_attachment].merge!({ association_type: 'User', association_id: current_user.id })
    image_attachment = ImageAttachment.new(params[:image_attachment])
    if image_attachment.valid?
      current_user.image_attachment = image_attachment
      render json: { image_url: current_user.image_attachment.try(:image).try(:url, :preview) },
             content_type: 'text/html',
             layout: false
    else
      render json: { error: I18n.t('image_attachment.upload_failures.common') },
             content_type: 'text/html',
             layout: false
    end
  end

  def create_gallery_attachment
    image_attachment = ImageAttachment.new(params[:image_attachment])
    if image_attachment.valid?
      image_attachment.save
      render json: { image_attachment_id: image_attachment.id, image_attachment_path: image_attachment_url(image_attachment), image_url: image_attachment.image.url(:gallery) }
    else
      render json: { error: I18n.t('image_attachment.upload_failures.common') }
    end
  end

  def show
    image_attachment = ImageAttachment.find(params[:id])
    send_file image_attachment.image.file.file, x_sendfile: true
  end

  private

  def remove_old_if_exists
    current_user.image_attachment.try(:destroy) if current_user.image_attachment
  end

end
