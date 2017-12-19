class RelationshipsController < ApplicationController
	# 14.32 - Access control for relationships
	before_action :logged_in_user

  def create
  	# 14.33 
  	user = User.find(params[:followed_id])
    current_user.follow(user)
    #redirect_to user
    
    # 14.36 - Responding to AJAX requests in the Relationships controller
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
  	# 14.33
  	user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    #redirect_to user

    # 14.36 - Responding to AJAX requests in the Relationships controller
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
