class Admin::UsersController < ApplicationController
  include Administratable

  before_filter :verify_access

  def index
    @users = User.unscoped.order('last_sign_in_at desc').by_page(params[:page], 20)
  end

end
