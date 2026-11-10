Rails.application.routes.draw do
  root "vendors#index"

  # Menu items are nested under vendors: /vendors/:vendor_id/menu_items
  resources :vendors, only: [:index] do
    resources :menu_items, only: [:index, :create]
  end

  # Order items are nested under orders: /orders/:order_id/order_items
  # PATCH /orders/:id places the order (checkout)
  resources :orders, only: [:show, :update] do
    resources :order_items, only: [:create, :destroy]
  end
end
