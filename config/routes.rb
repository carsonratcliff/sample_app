Rails.application.routes.draw do
  # 14.15 - Adding the routes for user relationships
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  # 14.15 - Following and follower actions to the Users controller
  resources :users do
    member do
      get :following, :followers
    end
  end

  # 11.1 - Account activation route
  resources :account_activations, only: [:edit]
  # 12.1 Password resets
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # 13.30 - Routes for Microposts resource (only create and destroy, no edit)
  resources :microposts,          only: [:create, :destroy]
  # 14.20 - Adding routes for user relationships
  resources :relationships,       only: [:create, :destroy]
end
