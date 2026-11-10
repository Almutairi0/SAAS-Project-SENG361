class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items

  # One SQL query (SUM over a JOIN) instead of loading every row in Ruby
  def total
    order_items.joins(:menu_item).sum("order_items.quantity * menu_items.price")
  end

  def item_count
    order_items.sum(:quantity)
  end
end
