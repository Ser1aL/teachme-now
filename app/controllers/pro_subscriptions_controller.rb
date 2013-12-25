class ProSubscriptionsController < ApplicationController

  before_filter :authenticate_user!, except: :create

  def create
    Rails.logger.info "======================="
    Rails.logger.info "PARAMS RECEIVED #{params.inspect}"
    Rails.logger.info "======================="

    render nothing: true
  end

  def new
    @liqpay_tokens = Lesson.new.build_tokens(current_user.id)
  end

end
