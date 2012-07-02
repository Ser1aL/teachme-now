class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: %w(edit update map_interest update_email edit_password)
  before_filter :attach_errors_to_current_user, only: %w(update_email edit_password edit)

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    # TODO
    # do user re-signin in case password is changed
    if current_user.update_attributes(params[:user])
      redirect_to current_user.skills.blank? ? interests_path : user_path(current_user)
    else
      redirect_to :back, flash: { errors: current_user.errors }
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

  private
    def attach_errors_to_current_user
      flash[:errors].messages.each{ |key, value| current_user.errors[key] = value[0] } unless flash[:errors].blank?
    end
end
