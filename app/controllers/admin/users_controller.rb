class Admin::UsersController < ApplicationController
  include Administratable

  before_filter :verify_access

  def index

  end

end
