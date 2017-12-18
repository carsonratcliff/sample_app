class PasswordResetsController < ApplicationController
	# 12.15 - the edit action for password reset
	before_action :get_user,   only: [:edit, :update]
    before_action :valid_user, only: [:edit, :update]
    # 12.16 - Update action for password reset
    before_action :check_expiration, only: [:edit, :update]    # Case (1)

  def new
  end

  # 12.5 - Create action for password resets
  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  # 12.16 - Update action for password reset
  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end

  private

  	# 12.16
  	def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

  	# 12.15 - before filters
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 12.15 - The edit action for password reset
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # 12.16 - Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

end
