class CertificatesController < ApplicationController

  def verify
    certificate = Certificate.enabled.where(code: params[:certificate_code], lesson_id: params[:lesson_id]).first

    respond_to do |format|
      format.html { render nothing: true }
      format.json do
        render json: certificate
      end
    end
  end

end
