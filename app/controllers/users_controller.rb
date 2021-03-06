class UsersController < ApplicationController
	# 10.15 - Requiring login before any user action
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers] # 10.35 - index added, 10.58 - destroy added, 14.24 following and followers addes
	# 10.25 - Introducing another (correct) user
	before_action :correct_user,   only: [:edit, :update]
	# 10.59 - Before filter restricting destroy action to only admin
	before_action :admin_user,     only: :destroy

	# 10.35 - Index action
	def index
		# 10.36 - Assigning all the users out of the db for use in view via @users
	#	@users - User.all
		# keep in mind for assigning all listings out of db (need to create corresponding view)

		# 10.46 - If paginating users
		@users = User.paginate(page: params[:page])
	end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    # 13.23 - Adding instance variable @microposts the user show action
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      # 11.23 - Adding account activation to user signup
      #UserMailer.account_activation(@user).deliver_now
      
      # 11.36 - Sending email via the user model object
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
  		#log_in @user
  		#flash[:success] = "Welcome to the sons of bitches, you son of a bitch"
  		#redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  	@user = User.find(params[:id])
  end

  # 10.8 - Update controller, largely identical to Create controller
  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		# Handle a sucessful update.
  		flash[:success] = "Profile updated"
      	redirect_to @user
  	else
  		render 'edit'
  	end
  end

  # 10.58 - Adding a destroy action (for Admin)
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # 14.25 - Following and followers actions
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

  	# 10.15 - Before filters

  	# Confirms a logged-in user.
  	#def logged_in_user
    #  unless logged_in?
    #  	# 10.31 - adding store_location to the logged-in user before filter
    #  	store_location
    #    flash[:danger] = "Please log in."
    #    redirect_to login_url
    #  end
    #end

    # 10.25 - Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 10.59 - Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
