class StaticPagesController < ApplicationController

  def show
    @content = StaticPage.find_by_name(params[:name]).try(:content)
  end

end
