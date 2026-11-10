class ApplicationController < ActionController::Base
  helper_method :current_order

  private

  # Orders this student placed earlier (kept so they can see the confirmation page)
  def placed_order_ids
    Array(session[:placed_order_ids])
  end

  # The current cart, or one of the student's own placed orders
  def own_order?(order)
    order.id == session[:order_id] || placed_order_ids.include?(order.id)
  end

  # The student's cart is the order whose id is kept in the session
  def current_order
    @current_order ||= Order.find_by(id: session[:order_id], status: "cart") || create_cart
  end

  def create_cart
    Order.create!.tap { |order| session[:order_id] = order.id }
  end
end
