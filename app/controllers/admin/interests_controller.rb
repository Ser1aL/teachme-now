class Admin::InterestsController < ApplicationController
  include Administratable

  before_filter :verify_access, :find_interest

  def index
    @interests = Interest.order('created_at desc').by_page(0, 20)
  end

  def new
    @interest = Interest.new
  end

  def create
    @interest = Interest.create(interest_params)

    if @interest.new_record?
      flash.now[:error] = @interest.errors.full_messages.first
      render 'new'
    else
      redirect_to admin_interests_path
    end
  end

  def edit
  end

  def update
    if @interest.update_attributes(interest_params)
      redirect_to admin_interests_path
    else
      flash[:error] = @interest.errors.full_messages.first
      redirect_to :back
    end
  end

  def destroy
    @interest.destroy
    redirect_to admin_interests_path
  end

  private

  def find_interest
    @interest = Interest.find(params[:id]) if params[:id].present?
  end

  def interest_params
    params.require(:interest).permit(:name, :description)
  end
end