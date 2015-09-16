Rails.application.routes.draw do

  resources :companies

  devise_for :users

  resources :gift_cards, only: [:new, :create] do
    member do
      put :redeem
      put :invalidate
    end
    collection do
      get :fisical
    end
  end

  resources :users, only: [:index] do
    member do
      put :make_pending
      put :make_regular
      put :make_admin
    end
    resources :api_keys, controller: 'users/api_keys', except: [:show]
  end

  root "gift_cards#index"

end
