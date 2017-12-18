class StaticPagesController < ApplicationController
  def home
  	# 13.40 - Adding a micropost inctance variable to home
  	#@micropost = current_user.microposts.build if logged_in?
	
	# 13.47 - Adding a feed instance var. to the home action
	if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    
  end

  def help
  end

  def about
  end

  def contact
  end

end
