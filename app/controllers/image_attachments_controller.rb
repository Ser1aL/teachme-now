class ImageAttachmentsController < ApplicationController

  before_filter :authenticate_user!, :remove_old_if_exists
  respond_to :json

  def create
    params[:image_attachment].merge!({ association_type: 'User', association_id: current_user.id })
    image_attachment = ImageAttachment.new(params[:image_attachment])
    if image_attachment.valid?
      current_user.image_attachment = image_attachment
      render json: { image_url: current_user.image_attachment.image(:medium) },
             content_type: 'text/html',
             layout: false
    else
      render json: { error: I18n.t('image_attachment.upload_failures.common') },
             content_type: 'text/html',
             layout: false
    end
  end

  private

  def remove_old_if_exists
    current_user.image_attachment.try(:destroy) if current_user.image_attachment
  end

end
