class FileAttachmentsController < ApplicationController

  before_filter :authenticate_user!, only: %w(create)
  respond_to :json

  def create
    file_attachment = FileAttachment.new(params[:file_attachment])
    if file_attachment.valid?
      file_attachment.save
      response_hash = { file_attachment_id: file_attachment.id, file_attachment_path: file_attachment_url(file_attachment) }
      #session[:file_attachments] ||= []
      #session[:file_attachments] << response_hash
      render json: response_hash
    else
      render json: { error: I18n.t('image_attachment.upload_failures.common') }
    end
  end

  def show
    file_attachment = FileAttachment.find(params[:id])
    send_file file_attachment.file.file.file, type: file_attachment.content_type, x_sendfile: true
  end

end
