class OrdersController < ApplicationController
  before_action :set_order
  before_action :require_current_cart, only: [:update]

  # GET /orders/:id  (the cart page, or the confirmation page once placed)
  def show
    @order_items = @order.order_items.includes(:menu_item).order(:created_at)
  end

  # PATCH /orders/:id  (checkout: place the order)
  # The status is set here on the server, never taken from params,
  # so there is nothing for strong parameters to permit.
  def update
    if @order.place
      session[:order_id] = nil # the next request gets a brand-new, empty cart
      remember_placed_order(@order)
      redirect_to order_path(@order),
                  notice: "Order ##{@order.id} confirmed. Total: #{helpers.sar(@order.total)}"
    else
      redirect_back fallback_location: order_path(@order),
                    alert: @order.errors.full_messages.to_sentence
    end
  end

  private

  # before_action filter: a student may see their current cart and orders they placed
  def set_order
    @order = Order.find(params[:id])
    head :forbidden unless own_order?(@order)
  end

  # before_action filter: only the cart kept in the session can be placed
  def require_current_cart
    head :forbidden unless @order.id == session[:order_id]
  end

  # Keep the last few placed orders so the student can still open the confirmation page
  def remember_placed_order(order)
    session[:placed_order_ids] = (placed_order_ids + [order.id]).last(10)
  end
end
