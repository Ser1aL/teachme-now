class HomeController < ApplicationController
  def index
    # avoid using database here
    redirect_to user_path(current_user) if current_user
  end
end
