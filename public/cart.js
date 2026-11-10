// CampusEats cart: add and remove items with fetch, no page reload.
(function () {
  "use strict";

  var TIMEOUT_MS = 8000;

  function init() {
    var cart = document.getElementById("cart");
    if (!cart) return;

    var menu = document.getElementById("menu");
    var list = document.getElementById("cart-items");
    var total = document.getElementById("cart-total");
    var empty = document.getElementById("cart-empty");
    var status = document.getElementById("cart-status");
    var error = document.getElementById("cart-error");
    var count = document.getElementById("cart-count");
    var placeOrder = document.getElementById("place-order");
    var tokenTag = document.querySelector('meta[name="csrf-token"]');
    var csrfToken = tokenTag ? tokenTag.content : "";

    function showError(message) {
      error.textContent = message;
      error.hidden = false;
    }

    function clearError() {
      error.textContent = "";
      error.hidden = true;
    }

    function updateTotals(data) {
      total.textContent = data.total_text;
      if (count) count.textContent = data.count;
      empty.hidden = list.children.length > 0;
      // "Place order" is only offered while the cart has items
      if (placeOrder) placeOrder.hidden = list.children.length === 0;
    }

    // fetch with a time limit: the network is not reliable and latency is not zero
    function request(url, method, body) {
      var controller = new AbortController();
      var timer = setTimeout(function () { controller.abort(); }, TIMEOUT_MS);
      return fetch(url, {
        method: method,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken
        },
        credentials: "same-origin",
        body: body ? JSON.stringify(body) : undefined,
        signal: controller.signal
      }).then(function (response) {
        return response.json().catch(function () { return {}; }).then(function (data) {
          if (!response.ok) {
            var message = (data.errors && data.errors.length)
              ? data.errors.join(". ")
              : "The server could not update your cart (error " + response.status + ").";
            throw new Error(message);
          }
          return data;
        });
      }, function (err) {
        if (err.name === "AbortError") {
          throw new Error("The request timed out. Please try again.");
        }
        throw new Error("Network problem: check your connection and try again.");
      }).finally(function () {
        clearTimeout(timer);
      });
    }

    function setBusy(button, busy, label) {
      // aria-disabled (not disabled) keeps keyboard focus on the button
      button.setAttribute("aria-disabled", busy ? "true" : "false");
      button.setAttribute("aria-busy", busy ? "true" : "false");
      button.classList.toggle("loading", busy);
      button.textContent = label;
    }

    function addToCart(button) {
      if (button.getAttribute("aria-busy") === "true") return; // ignore double clicks
      var name = button.getAttribute("aria-label").replace(/^Add /, "").replace(/ to cart$/, "");
      clearError();
      setBusy(button, true, "Adding…");
      status.textContent = "Adding " + name + "…";

      request(menu.dataset.cartUrl, "POST", {
        order_item: { menu_item_id: button.dataset.menuItemId, quantity: 1 }
      }).then(function (data) {
        var template = document.createElement("template");
        template.innerHTML = data.html.trim();
        var row = template.content.firstElementChild;
        var existing = document.getElementById(row.id);
        if (existing) {
          existing.replaceWith(row);
        } else {
          list.appendChild(row);
        }
        updateTotals(data);
        status.textContent = name + " added. Total " + data.total_text + ".";
      }).catch(function (err) {
        status.textContent = "";
        showError(err.message);
      }).finally(function () {
        setBusy(button, false, "Add to cart");
      });
    }

    function removeFromCart(form) {
      var row = form.closest(".cart-row");
      var button = form.querySelector("button");
      clearError();
      if (button) setBusy(button, true, "Removing…");
      status.textContent = "Removing item…";

      request(form.action, "DELETE").then(function (data) {
        row.remove();
        updateTotals(data);
        status.textContent = "Item removed. Total " + data.total_text + ".";
      }).catch(function (err) {
        status.textContent = "";
        showError(err.message);
        if (button) setBusy(button, false, "Remove");
      });
    }

    if (menu) {
      menu.addEventListener("click", function (event) {
        var button = event.target.closest(".add-to-cart");
        if (button) addToCart(button);
      });
    }

    // Event delegation: works for rows that were added after the page loaded
    list.addEventListener("submit", function (event) {
      var form = event.target.closest("form.remove-item");
      if (!form) return;
      event.preventDefault();
      removeFromCart(form);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
