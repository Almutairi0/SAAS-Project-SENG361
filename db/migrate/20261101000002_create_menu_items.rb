class CreateMenuItems < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_items do |t|
      t.references :vendor, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.boolean :sold_out, null: false, default: false
      t.timestamps
    end
  end
end
