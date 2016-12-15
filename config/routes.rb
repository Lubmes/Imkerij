Rails.application.routes.draw do
  devise_for :users, path: 'u', controllers: { registrations: "registrations" }
  resources 'users' do
    resources 'orders'
  end

  resources 'orders', only: [:index] do
    member do
      get 'empty'
      get 'check_out'
      get 'to_bank'
    end
  end

  root 'welcome#home'
  get 'admin', to: 'welcome#admin'

  get 'shop', to: 'categories#index', as: 'shop'
  resources 'categories', except: [:index] do
    resources 'products'
    resources 'pictures' do
      member do
        post 'visabile_toggle'
      end
    end
  end
  resources 'products' do
    resources 'pictures' do
      member do
        post 'visabile_toggle'
      end
    end
  end
  resources 'bookings'
  resources 'events'
end
