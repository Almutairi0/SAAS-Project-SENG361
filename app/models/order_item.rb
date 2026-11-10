class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 10 }
  validates :menu_item_id, uniqueness: { scope: :order_id }
  validate :menu_item_not_sold_out, if: -> { new_record? || quantity_changed? }
  validate :order_still_a_cart
  before_destroy :ensure_order_still_a_cart

  def subtotal
    quantity * menu_item.price
  end

  private

  def menu_item_not_sold_out
    errors.add(:base, "#{menu_item.name} is sold out") if menu_item&.sold_out?
  end

  # A placed order is final: no items can be added, changed or removed
  def order_still_a_cart
    errors.add(:base, "This order has already been placed and can't be changed.") if order&.placed?
  end

  def ensure_order_still_a_cart
    return unless order&.placed?

    order_still_a_cart
    throw :abort
  end
end
