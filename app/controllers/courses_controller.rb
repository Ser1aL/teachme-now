class CoursesController < ApplicationController

  before_filter :authenticate_user!, except: %w(show index)
  #before_filter :preload_interest_tree, only: %w(edit new)

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      render :action => "show"
    else
      redirect_to :back, flash: { errors: current_user.errors }
    end
  end

  def create
    @course = Course.create(params[:course].merge({owner_id: current_user.id}))
    if @course.new_record?
      render :action => 'new'
    else
      redirect_to course_path(@course)
    end
  end

  #private
  #  def preload_interest_tree
  #    @interests = Interest.includes(:sub_interests)
  #  end
end