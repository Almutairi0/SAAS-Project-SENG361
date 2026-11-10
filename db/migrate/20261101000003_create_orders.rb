class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: "cart"
      t.timestamps
    end
  end
end
