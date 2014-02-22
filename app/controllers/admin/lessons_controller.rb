class Admin::LessonsController < ApplicationController
  include Administratable

  before_filter :verify_access

  def index
    @lessons = Lesson.unscoped.order(created_at: :desc).by_page(params[:page], 20)
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

end
