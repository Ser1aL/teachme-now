class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: %w(edit update map_interest)

  def show
    # TODO
    # action shows user profile with lessons
  end

  def edit
    # TODO
    # user profile edits
  end

  def update
    # TODO
    # updates profile
  end

  def map_interest
    if params[:trigger_to] == 'true'
      current_user.skills.find_or_create_by_sub_interest_id(params[:sub_interest_id])
    else
      current_user.skills.find_by_sub_interest_id(params[:sub_interest_id]).destroy
    end
    respond_with 1
  end

  def update_email

  end
end
