class Order < ApplicationRecord
  STATUSES = %w[cart placed].freeze

  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  validates :status, inclusion: { in: STATUSES }
  validate :must_have_items_to_place, if: -> { will_save_change_to_status?(to: "placed") }
  validate :placed_order_is_final, on: :update, if: -> { status_in_database == "placed" }

  def cart?
    status == "cart"
  end

  def placed?
    status == "placed"
  end

  # Checkout: turns the cart into a placed order. Returns false (with errors) if it can't.
  def place
    self.status = "placed"
    return true if save

    self.status = status_in_database # stay a cart; errors are kept for the flash
    false
  end

  # One SQL query (SUM over a JOIN) instead of loading every row in Ruby
  def total
    order_items.joins(:menu_item).sum("order_items.quantity * menu_items.price")
  end

  def item_count
    order_items.sum(:quantity)
  end

  private

  def must_have_items_to_place
    errors.add(:base, "Your cart is empty. Add an item before placing the order.") unless order_items.exists?
  end

  def placed_order_is_final
    errors.add(:base, "This order has already been placed and can't be changed.") if changed?
  end
end
