class Admin::CampaignsController < ApplicationController

  include Administratable

  before_filter :verify_access

  def index
    @campaigns = Campaign.by_page(params[:page], 20)
  end

  def show
    @campaign = Campaign.find(params[:id])
    @visits = @campaign.visits.reverse_order.by_page(params[:page], 20)

    @summary_visits = Visit.
        select('created_at date, count(id) total_visits, count(distinct ip) unique_visits').
        where(campaign_id: params[:id]).
        group('date(created_at)').
        order('id desc').
        limit(30)
  end

end