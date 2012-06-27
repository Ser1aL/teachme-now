class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: %w(edit update map_interest)

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
    else
      redirect_to :back
    end
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

  def edit_password
  end
end
