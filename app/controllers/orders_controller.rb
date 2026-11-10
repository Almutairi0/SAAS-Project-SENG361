class OrdersController < ApplicationController
  # GET /orders/:id  (the cart page)
  def show
    @order = Order.find(params[:id])
    return head :forbidden unless @order.id == session[:order_id]

    @order_items = @order.order_items.includes(:menu_item).order(:created_at)
  end
end
