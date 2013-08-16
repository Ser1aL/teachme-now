class StaticPagesController < ApplicationController

  def show
    @content = StaticPage.find_by_name(params[:name]).try(:content)
  end

  def feedback
    UserMailer.feedback(params[:feedback]).deliver
    redirect_to :back
  end
end
