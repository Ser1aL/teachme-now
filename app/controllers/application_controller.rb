class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: ->{
    # TODO change this to Static#not_found or Static#internal_error pages
    redirect_to root_path, flash: { error: I18n.t('error.record_not_found') } unless request.xhr?
  }

  after_filter :update_current_user


  private

  def update_current_user
    current_user.try :touch
  end


end
