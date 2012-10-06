class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: ->{ redirect_to root_path, flash: { error: I18n.t('error.record_not_found') } }
end
