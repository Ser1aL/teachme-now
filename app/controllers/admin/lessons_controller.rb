class Admin::LessonsController < ApplicationController
  include Administratable

  before_filter :verify_access

  def index
    @lessons = Lesson.unscoped.order('created_at desc').includes(:interest, :sub_interest).by_page(params[:page], 20)
  end

  def show
    @lesson = Lesson.find(params[:id])
  end

  def contact_teacher
    @lesson = Lesson.find(params[:lesson_id])
  end

  def confirm
    Lesson.find(params[:lesson_id]).mark_enabled and redirect_to :back
  end

  def unconfirm
    Lesson.find(params[:lesson_id]).mark_disabled and redirect_to :back
  end

  def send_confirmation
    flash[:notice] = I18n.t('admin.successfully_sent')
    UserMailer.async_send(:lesson_confirmation, params[:lesson_id], params[:comment])

    redirect_to :back
  end

  def send_issues
    if params[:comment].blank?
      flash[:error] = I18n.t('admin.issues_send_error')
    else
      flash[:notice] = I18n.t('admin.successfully_sent')
      UserMailer.async_send(:lesson_issues, params[:lesson_id], params[:comment])
    end

    redirect_to :back
  end

end
