class MicropostsController < ApplicationController
  # 13.34 - Adding authorrization to the micropost controller actions
  before_action :logged_in_user, only: [:create, :destroy]
  # 13.52 - Adding destroy action (correct user requisite)
  before_action :correct_user,   only: :destroy

  # 13.36 - Microposts controller CREATE action
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
    	# 13.50 - Adding an empty feed_items inst. var. when micropost submission fails
    	@feed_items = []
      render 'static_pages/home'
    end
  end

  # 13.52 - Microposts DESTROY action
  def destroy
  	@micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # 13.52
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
