class SessionsController < ApplicationController
  
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		#redirect_to user
  		# 10.32 - Adjusting redirect for friendly forwarding
  		redirect_back_or user

  	# 9.27 - Improved Remember-me 
  	#?user = User.find_by(email: params[:session][:email].downcase)
    #if ?user && ?user.authenticate(params[:session][:password])
    #  log_in ?user
    #  params[:session][:remember_me] == '1' ? remember(?user) : forget(?user)
    #  redirect_to ?user
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	# 9.16
    log_out if logged_in?
    redirect_to root_url
  end

end
