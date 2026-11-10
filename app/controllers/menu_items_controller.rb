class MenuItemsController < ApplicationController
  before_action :set_vendor

  # GET /vendors/:vendor_id/menu_items  (the vendor's menu page)
  def index
    load_menu_page
    @menu_item = MenuItem.new(vendor: @vendor)
  end

  # POST /vendors/:vendor_id/menu_items  (vendor publishes an item)
  def create
    @menu_item = @vendor.menu_items.new(menu_item_params)
    if @menu_item.save
      redirect_to vendor_menu_items_path(@vendor), notice: "#{@menu_item.name} was published."
    else
      load_menu_page
      render :index, status: 422
    end
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def load_menu_page
    @menu_items = @vendor.menu_items.order(:name)
    # includes(:menu_item) avoids the N+1 query when the cart rows print item names
    @order_items = current_order.order_items.includes(:menu_item).order(:created_at)
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :sold_out)
  end
end
