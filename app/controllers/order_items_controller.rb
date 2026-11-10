class OrderItemsController < ApplicationController
  before_action :set_order
  before_action :require_cart

  # POST /orders/:order_id/order_items(.json)
  def create
    @order_item = @order.order_items.find_or_initialize_by(menu_item_id: order_item_params[:menu_item_id])
    requested = order_item_params[:quantity].presence || 1
    # A new row takes the requested quantity; an existing row adds to it
    @order_item.quantity = @order_item.new_record? ? requested : @order_item.quantity + requested.to_i

    respond_to do |format|
      if @order_item.menu_item.nil?
        format.json { render json: { errors: ["Menu item not found"] }, status: :not_found }
        format.html { redirect_back fallback_location: order_path(@order), alert: "Menu item not found" }
      elsif @order_item.save
        format.json { render json: cart_json.merge(html: row_html), status: :created }
        format.html { redirect_back fallback_location: order_path(@order), notice: "Added to cart." }
      else
        format.json { render json: { errors: @order_item.errors.full_messages }, status: 422 }
        format.html { redirect_back fallback_location: order_path(@order), alert: @order_item.errors.full_messages.to_sentence }
      end
    end
  end

  # DELETE /orders/:order_id/order_items/:id(.json)
  def destroy
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy

    respond_to do |format|
      format.json { render json: cart_json }
      format.html { redirect_back fallback_location: order_path(@order), notice: "Removed from cart." }
    end
  end

  private

  # before_action filter: load the order from the URL and make sure it belongs to this student
  # (someone else's order: 403; the student's own placed order: 422 from require_cart)
  def set_order
    @order = Order.find(params[:order_id])
    head :forbidden unless own_order?(@order)
  end

  # before_action filter: a placed order is final, so refuse with 422
  def require_cart
    return if @order.cart?

    message = "This order has already been placed and can't be changed."
    respond_to do |format|
      format.json { render json: { errors: [message] }, status: 422 }
      format.html { redirect_back fallback_location: order_path(@order), alert: message, status: :see_other }
    end
  end

  # Strong parameters: only these two fields can be set from the request
  def order_item_params
    params.require(:order_item).permit(:menu_item_id, :quantity)
  end

  def cart_json
    { id: helpers.dom_id(@order_item),
      total: @order.total.to_f,
      total_text: helpers.sar(@order.total),
      count: @order.item_count }
  end

  def row_html
    render_to_string(partial: "order_items/order_item",
                     formats: [:html],
                     locals: { order_item: @order_item })
  end
end
