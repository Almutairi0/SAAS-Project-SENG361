# Sample data: bin/rails db:seed (safe to run more than once)
burger = Vendor.find_or_create_by!(name: "Burger Corner")
shawarma = Vendor.find_or_create_by!(name: "Shawarma House")
coffee = Vendor.find_or_create_by!(name: "Coffee Stop")

[
  [burger,   "Chicken Burger",   15.00, false],
  [burger,   "Beef Burger",      18.00, false],
  [burger,   "French Fries",      7.00, false],
  [burger,   "Spicy Wrap",       14.00, true],
  [shawarma, "Chicken Shawarma", 10.00, false],
  [shawarma, "Falafel Plate",     9.00, false],
  [shawarma, "Mixed Grill",      28.00, true],
  [coffee,   "Arabic Coffee",     6.00, false],
  [coffee,   "Latte",            13.00, false],
  [coffee,   "Date Muffin",       8.00, false]
].each do |vendor, name, price, sold_out|
  item = vendor.menu_items.find_or_initialize_by(name: name)
  item.update!(price: price, sold_out: sold_out)
end

puts "Seeded #{Vendor.count} vendors and #{MenuItem.count} menu items."
