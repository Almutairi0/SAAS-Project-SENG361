# CampusEats — SENG 361 Course Assignment (Version B)

A small Rails app for ordering from the university food court. Vendors publish
menu items; students add items to a cart with AJAX (no page reload) and place
the order at checkout.

## Requirements

- Ruby 3.1 or newer
- Bundler (`gem install bundler`)
- SQLite 3 (the `sqlite3` gem ships prebuilt for Windows, macOS and Linux)

## Setup

```bash
bundle install
bin/rails db:migrate
bin/rails db:seed      # sample vendors and menu items (one sold-out item per vendor)
bin/rails server
```

On Windows use `ruby bin/rails ...` if `bin/rails` does not run directly.

Open http://localhost:3000, pick a vendor, and press **Add to cart**.

## What to try

| Action | Expected result |
|---|---|
| Add "Chicken Burger" (Burger Corner) | Row appears in the cart, total becomes 15.00 SAR, no reload |
| Add it again | Same row shows × 2, total 30.00 SAR |
| Add "Spicy Wrap" (sold out) | Red error: "Spicy Wrap is sold out" |
| Stop the server, then add an item | Error: "Network problem: check your connection and try again." |
| Tab to a button, press Enter or Space | Works with the keyboard |
| Publish an item with price 0 | Form shows "Price must be greater than 0" |
| Add "Chicken Burger", then press **Place order** | Confirmation page: "Order #N confirmed. Total: 15.00 SAR", item listed with no Remove button |
| Open the cart after placing an order | New empty cart, Cart (0), no **Place order** button |
| Remove the last item from the cart | **Place order** button disappears |
| Add or remove an item on a placed order (e.g. with curl) | Refused: 422 with JSON error "This order has already been placed and can't be changed." |

## Routes

| HTTP method | URI | Controller#action |
|---|---|---|
| GET | /vendors | vendors#index |
| GET | /vendors/:vendor_id/menu_items | menu_items#index |
| POST | /vendors/:vendor_id/menu_items | menu_items#create |
| GET | /orders/:id | orders#show |
| PATCH | /orders/:id | orders#update (place the order) |
| POST | /orders/:order_id/order_items(.json) | order_items#create |
| DELETE | /orders/:order_id/order_items/:id(.json) | order_items#destroy |

`/` (root) points to `vendors#index`. Run `bin/rails routes` to see them all.

## Where things are

- Models: `app/models/` (Vendor, MenuItem, Order, OrderItem)
- Migrations: `db/migrate/`
- Cart controller: `app/controllers/order_items_controller.rb`
- Checkout (place order): `app/controllers/orders_controller.rb#update`, `Order#place`
- Cart row partial: `app/views/order_items/_order_item.html.erb`
- AJAX client: `public/cart.js`
- Cucumber feature (Part A): `docs/order_food.feature`

## Who drove which part

| Part | Driver | Navigator(s) |
|---|---|---|
| A — User stories, feature file, sketch, estimate | Yousef | Abdsalam |
| B — Models, migrations, validations, routes | Abdullah | Abdulaziz |
| B — OrderItemsController, partial, JSON | Abdulaziz | Abdullah |
| C — JavaScript client (fetch, DOM, accessibility) | Abdsalam | Yousef |
| D — Reflection | All four | All four |

## Sources and AI use

- Rails Guides (Active Record Associations, Validations, Routing, Action Controller)
- MDN Web Docs (Fetch API, AbortController, ARIA)
- Claude (Anthropic) was used to help draft code and text; we reviewed, ran and tested all of it.
