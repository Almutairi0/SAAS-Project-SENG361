class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 10 }
  validates :menu_item_id, uniqueness: { scope: :order_id }
  validate :menu_item_not_sold_out, if: -> { new_record? || quantity_changed? }

  def subtotal
    quantity * menu_item.price
  end

  private

  def menu_item_not_sold_out
    errors.add(:base, "#{menu_item.name} is sold out") if menu_item&.sold_out?
  end
end
