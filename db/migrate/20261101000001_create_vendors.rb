class CreateVendors < ActiveRecord::Migration[7.2]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
