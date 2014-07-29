class Admin::SubInterestsController < ApplicationController
  include Administratable

  before_filter :verify_access, :find_sub_interest

  def index
    @sub_interests = SubInterest.order('created_at desc').by_page(params[:page], 20)
  end

  def new
    @sub_interest = SubInterest.new
  end

  def create
    @sub_interest = SubInterest.create(sub_interest_params)

    if @sub_interest.new_record?
      flash.now[:error] = @sub_interest.errors.full_messages.first
      render 'new'
    else
      redirect_to admin_sub_interests_path
    end
  end

  def edit
  end

  def update
    if @sub_interest.update_attributes(sub_interest_params)
      redirect_to admin_sub_interests_path
    else
      flash[:error] = @sub_interest.errors.full_messages.first
      redirect_to :back
    end
  end

  def destroy
    @sub_interest.destroy
    redirect_to admin_sub_interests_path
  end

  private

  def find_sub_interest
    @sub_interest = SubInterest.find(params[:id]) if params[:id].present?
  end

  def sub_interest_params
    params.require(:sub_interest).permit(:name, :description, :interest_id)
  end
end