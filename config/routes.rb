require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :wishlists, only: %i[index create destroy]
  resources :orders, only: %i[index show]

  resource :cart, only: %i[show destroy] do
    post :add_item
    patch :update_item
    delete :remove_item
  end

  get "checkout", to: "checkout#show"
  get "checkout/address", to: "checkout#address"
  post "checkout/address", to: "checkout#create_address"
  get "checkout/review", to: "checkout#review"
  post "checkout/review", to: "checkout#review"
  post "checkout/place_order", to: "checkout#place_order"

  get "search", to: "search#index"

  namespace :account do
    get "dashboard", to: "dashboard#index"
    resources :orders, only: %i[index show] do
      member { patch :cancel }
    end
    resources :addresses
    get "profile", to: "profile#show"
    patch "profile", to: "profile#update"
  end

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :products do
      member do
        patch :toggle_active
        patch :toggle_featured
      end
    end
    resources :categories do
      member do
        patch :toggle_active
        patch :move
      end
    end
    resources :orders do
      member do
        patch :update_status
        get :invoice
      end
    end
    resources :customers, only: %i[index show]
    resources :reports, only: :index
    resource :settings, only: %i[show update]
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#create_contact"
  get "size-guide", to: "pages#size_guide"
  get "shipping", to: "pages#shipping"
  get "returns", to: "pages#returns"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
  get "faq", to: "pages#faq"
end
