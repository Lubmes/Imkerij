Rails.application.routes.draw do

  devise_for :users, path: 'u', controllers: { registrations: "registrations" }
  resources 'users' do
    resources 'orders'
  end

  root 'welcome#home'
  get 'admin', to: 'welcome#admin'
  resources 'events'
  get 'shop', to: 'shop#index', as: 'shop'

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

  resources 'orders', only: [:index] do
    member do
      get 'empty'
      get 'check_out'
      get 'to_bank'
      get 'confirmation'
    end
  end

end
