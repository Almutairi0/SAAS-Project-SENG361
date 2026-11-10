class ApplicationController < ActionController::Base
  helper_method :current_order

  private

  # The student's cart is the order whose id is kept in the session
  def current_order
    @current_order ||= Order.find_by(id: session[:order_id]) || create_cart
  end

  def create_cart
    Order.create!.tap { |order| session[:order_id] = order.id }
  end
end
