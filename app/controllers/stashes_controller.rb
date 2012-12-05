class StashesController < ApplicationController
  
  def index
    if current_user
      @articles = current_user.articles.sorted.paginate(:page => params[:page])
    else
      redirect_to :root
    end
  end

end
