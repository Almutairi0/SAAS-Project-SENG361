class VendorsController < ApplicationController
  # GET /vendors
  def index
    @vendors = Vendor.order(:name)
  end
end
