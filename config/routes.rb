Rails.application.routes.draw do
  root "vendors#index"

  # Menu items are nested under vendors: /vendors/:vendor_id/menu_items
  resources :vendors, only: [:index] do
    resources :menu_items, only: [:index, :create]
  end

  # Order items are nested under orders: /orders/:order_id/order_items
  resources :orders, only: [:show] do
    resources :order_items, only: [:create, :destroy]
  end
end
