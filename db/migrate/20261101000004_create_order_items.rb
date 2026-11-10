class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.timestamps
    end
    # One cart row per menu item; adding the same item again raises the quantity
    add_index :order_items, [:order_id, :menu_item_id], unique: true
  end
end
