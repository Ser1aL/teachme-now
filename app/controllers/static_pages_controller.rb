class StaticPagesController < ApplicationController

  def show
    @content = StaticPage.find_by_name(params[:name]).try(:content)
  end

  def feedback
    form_data = ContactsForm.new(params[:feedback])

    if form_data.valid?
      UserMailer.feedback(params[:feedback]).deliver
    else
      flash[:error] = form_data.errors.messages
    end

    redirect_to :back
  end
end
