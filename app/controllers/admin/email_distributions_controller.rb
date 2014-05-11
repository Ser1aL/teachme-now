class Admin::EmailDistributionsController < ApplicationController

  include Administratable

  before_filter :verify_access

  def new
  end

  def create
    params[:users].reject!(&:blank?)
    params[:users].each do |user_email|
      UserMailer.async_send(:free_email, user_email, params[:email_text])
    end

    redirect_to :back, notice: I18n.t('admin.email_distributions.mail_sent_to', user_list: params[:users].join(', '))
  end

end