class ApplicationController < ActionController::Base
  protect_from_forgery

  prepend_before_filter :update_current_user
  before_filter :preload_interest_tree, :track_visit
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def update_current_user
    current_user.try :touch
  end

  def preload_interest_tree
    @interests = Interest.includes(:sub_interests)
  end

  def track_visit
    return if params[:cmp].blank?

    campaign = Campaign.find(params[:cmp]) rescue nil
    return unless campaign

    campaign.visits.create(ip: request.remote_ip)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end

  def deprecated_route
    redirect_to(root_path, notice: I18n.t('deprecated_route')) and return
  end

end
