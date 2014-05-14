class Admin::CoursesController < ApplicationController
  include Administratable

  before_filter :verify_access

  def index
    @courses = Course.order('created_at desc').includes(:lessons).by_page(params[:page], 20)
  end

  def show
    @course = Course.find(params[:id])
  end

end
