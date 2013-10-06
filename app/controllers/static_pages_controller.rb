class StaticPagesController < ApplicationController

  def show
    @content = StaticPage.find_by_name(params[:name]).try(:content)
    @errors = params[:errors]
    @feedback = params[:feedback] || {user_name: '', user_email: '', user_message: ''}
  end

  def feedback
    form_data = ContactsForm.new(params[:feedback])

    if form_data.valid?
      #UserMailer.feedback(params[:feedback]).deliver
      redirect_to root_path, notice: I18n.t('mailer.feedback_notice')
    else
      errors = form_data.errors.messages
      feedback = params[:feedback]
      redirect_to action: :show, page_name: 'contacts', errors: errors, feedback: feedback
    end
  end
end
