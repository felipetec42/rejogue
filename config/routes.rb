Rails.application.routes.draw do
  require 'sidekiq/web'

  mount ActionCable.server => '/cable'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'sessions', passwords: 'users/passwords', :omniauth_callbacks => 'users/omniauth_callbacks' }, path_names: { sign_up: 'sign-up'}
  devise_scope :user do
    # post "users/getaddress/:zipcode" => "users/registrations#get_address"
    get 'users/sign_in', to: 'home#index'
  end

  unauthenticated do
    root to: "home#index", as: :unauthenticated_root
  end

  root to: "home#index"

  resources :sobre, only: [:index], path: "sobre"
  resources :compra, only: [:index], path: "compra"
  resources :venda, only: [:index], path: "venda"
  resources :contato, only: [:index], path: "contato"

  resources :home, only: [:index], path: "contato"

  authenticate :user, lambda { |u| !u.email.nil? } do

    root to: "logged/jogos#index"

    namespace :logged do
      resources :home, only: [:index], path: "jogos"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
