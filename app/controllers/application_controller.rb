class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: ->{
    # TODO change this to Static#not_found or Static#internal_error pages
    redirect_to root_path, flash: { error: I18n.t('error.record_not_found') } unless request.xhr?
  }
end
