class ApplicationController < ActionController::Base
  protect_from_forgery

  prepend_before_filter :update_current_user
  before_filter :preload_interest_tree, :track_visit

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

end
