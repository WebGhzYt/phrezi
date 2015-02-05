require 'api_constraints'

Ballyhooweb::Application.routes.draw do

  mount_opro_oauth
  devise_for :users, :controllers => {:sessions => "sessions", confirmations: 'confirmations'}

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users
      resources :establishments do
        member do
          get :checkin
          get :checkout
          get :mystatus
          get :boosters
          get :participating_patrons
        end
        collection do
          get 'near'
          get 'within_box'
          get 'participating'
        end
      end
      resources :enrolled_challenges
      resources :ballyhoos, only: :show
      resources :checkin_ballyhoos, controller: 'ballyhoos', type: 'CheckinBallyhoo'
      resources :purchase_ballyhoos, controller: 'ballyhoos', type: 'PurchaseBallyhoo'
      resources :task_ballyhoos, controller: 'ballyhoos', type: 'TaskBallyhoo'
      resources :boosters do
        collection do
          get :current_boosters
          get :get_booster
        end
      end
      resources :loyal_patrons do
        collection do
          post :purchase_transaction
          post :booster_transactions
        end
      end
      resources :challenges
      get 'me' => "users#me"
      get 'mystatus' => "users#my_status"
      get 'mycart' => "users#mycart"
    end
  end
  namespace :api, defaults: {format: 'json'} do
    namespace :pos, defaults: {format: 'json'} do
      get 'current_establishment' => "pos#current_establishment"
      post 'current_establishment' => "pos#set_current_establishment"
      get 'patrons' => "pos#patron_listing"
      get 'patron/:id' => "pos#patron_detail"
      get 'my_establishments' => "pos#my_establishments"
      get 'patron/:id/cart' => "pos#patron_cart_show"
      put 'patron/:id/cart/update' => "pos#patron_cart_update"
      get 'patron/:id/cart_process' => "pos#cart_process"
      get 'patron/:id/cart_reset' => "pos#cart_reset"
    end
  end

  authenticated :user do
    root to: 'challenges#index', as: :authenticated_root
    get '/about'=> "info#about"
    resources :employees
    resources :categories
    resources :menu_items
    resources :loyal_patrons
    resources :establishments, except: :show do
      post :set_current, on: :member
      get :remove_menu_items, on: :collection
      get :remove_employee, on: :collection
      get :manualpurchase, on: :member
      post :create_manualpurchase, on: :member
      get :check_map_position, on: :collection
      patch :crop, on: :member
    end
    resources :challenges, except: :new do
      get :get_ballyhoo_form, on: :collection
      resources :enrolled_challenges
    end
    resources :ballyhoos, except: :destroy  do
      member do
        get 'change_status'
        get 'destroy', as: :delete
      end
      collection do
        get :show_active_boosters
        get :all_boosters
      end
    end
    resources :checkin_ballyhoos, controller: 'ballyhoos', type: 'CheckinBallyhoo' do
      get  :manual_checkin, on: :collection
      get  :manual_checkout, on: :collection
      get  :manual, on: :collection
    end
    resources :purchase_ballyhoos, controller: 'ballyhoos', type: 'PurchaseBallyhoo'
    resources :task_ballyhoos, controller: 'ballyhoos', type: 'TaskBallyhoo'
    resources :products
    resources :product_categories
    get 'statistics/index'
    post 'statistics/calculate'
  end
  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
    root to: 'home#index'
  end
  get '/about' => "info#about"
  get '/terms' => "info#terms"
end
