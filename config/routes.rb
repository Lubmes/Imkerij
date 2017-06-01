Rails.application.routes.draw do

  devise_for :users, path: 'u', controllers: { registrations: "registrations", sessions: "sessions" }
  resources 'users' do
    resources 'orders'
    resources 'deliveries'
  end

  # pages
  root 'pages#home'
  get 'facilities', to: 'pages#facilities', as: 'facilities'
  get 'expo', to: 'pages#expo', as: 'expo'
  get 'route', to: 'pages#route', as: 'route'
  get 'extras', to: 'pages#extras', as: 'extras'
  resources 'pages', only: [:edit, :update] do
    resources 'pictures' do
      member do
        get 'visability_toggle'
      end
    end
  end
  get 'pages/1', to: 'pages#home'
  get 'pages/2', to: 'pages#facilities'
  get 'pages/3', to: 'pages#expo'
  get 'pages/4', to: 'pages#route'
  get 'pages/5', to: 'pages#extras'

  get 'admin', to: 'welcome#admin'
  resources 'events' do
    resources 'pictures'
  end
  get 'shop', to: 'shop#index', as: 'shop'

  resources 'categories', except: [:index] do
    member do
      get 'move_higher'
      get 'move_lower'
    end
    resources 'products'
    resources 'pictures' do
      member do
        get 'visability_toggle'
      end
    end
  end
  resources 'products' do
    member do
      get 'move_higher'
      get 'move_lower'
    end
    resources 'pictures' do
      member do
        get 'visability_toggle'
      end
    end
  end

  resources 'selections' do
    resources 'corrections'
  end

  resources 'orders', only: [:index] do
    member do
      get 'empty'
      patch 'set_package_delivery'
      get 'check_out'
      get 'confirm'
      get 'pay'
      get 'success'
      get 'problem'
    end
    resources 'invoices', only: [:show] do
      member do
        get 'sent_out'
        get 'refund'
        get 'print'
      end
      resource 'download', only: [:show]
    end
  end
end
