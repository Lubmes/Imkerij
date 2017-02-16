Rails.application.routes.draw do

  devise_for :users, path: 'u'#, controllers: { registrations: "registrations" }
  resources 'users' do
    resources 'orders'
    resources 'deliveries'
  end

  root 'welcome#home'
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

  resources 'bookings' do
    resources 'corrections'
  end

  resources 'orders', only: [:index] do
    member do
      get 'empty'
      get 'check_out'
      get 'confirm'
      get 'pay'
      get 'success'
    end
    resources 'invoices', only: [:show] do
      member do
        get 'sent_out'
      end
      resource 'download', only: [:show]
    end
  end
end
