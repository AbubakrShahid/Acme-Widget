# 🛒 Acme Widget Co - Shopping Basket System

This is a Ruby-based proof of concept for Acme Widget Co’s new sales system. It models a shopping basket with configurable product pricing, delivery rules, and promotional offers.

---

## Setup Instructions

### 1. **Install Dependencies**

To get started, install the required dependencies using `Bundler`. Ensure you have [Bundler](https://bundler.io/) installed, and then run:

```bash
bundle install
```

### 2. **Running Tests**

```
rspec
```

### 3. **Executing the Application**

```
ruby basket.rb
```

---

## ✨ Features

- Add items to basket using product codes (`B01`, `G01`, `R01`)
- Automatically applies:
  - Product pricing rules
  - Promotional offers
  - Delivery charges based on order value
- Clean and modular design using Ruby classes
- Truncates total cost to two decimal places without rounding
- Easily extendable for future rules and products

---

## 📦 Products

| Product       | Code | Price  |
|---------------|------|--------|
| Red Widget    | R01  | $32.95 |
| Green Widget  | G01  | $24.95 |
| Blue Widget   | B01  | $7.95  |

## 💥 Special Offers

### Red Widget (R01) – Buy One, Get One Half Price

- **Unit Price:** $32.95
- **Offer:** Buy one, get the second at half price.
- **Color:** Red
- Applies to each **pair** of Red Widgets.
- An **odd item** (unpaired) is charged at **full price**.

#### 📦 Pricing Examples

| Quantity | Calculation                                      | Total Price |
|----------|--------------------------------------------------|-------------|
| 1        | 1 × $32.95                                       | **$32.95**  |
| 2        | 1 × $32.95 + 1 × $16.48                          | **$49.43**  |
| 3        | (2 for BOGO) + 1 full price = $49.43 + $32.95    | **$82.38**  |
| 4        | 2 BOGO pairs = 2 × ($32.95 + $16.48)             | **$98.86**  |
| 5        | 2 BOGO pairs + 1 full price = $98.86 + $32.95    | **$131.81** |
| 6        | 3 BOGO pairs = 3 × ($32.95 + $16.48)             | **$148.28** |

---

### Green Widget (G01) – Regular Price

- **Unit Price:** $24.95
- **Color:** Green
- No special offers – always charged at full price.

#### 📦 Pricing Example

| Quantity | Calculation            | Total Price |
|----------|------------------------|-------------|
| 1        | 1 × $24.95             | **$24.95**  |
| 2        | 2 × $24.95             | **$49.90**  |
| 3        | 3 × $24.95             | **$74.85**  |

---

### Blue Widget (B01) – Regular Price

- **Unit Price:** $7.95
- **Color:** Blue
- No special offers – always charged at full price.

#### 📦 Pricing Example

| Quantity | Calculation            | Total Price |
|----------|------------------------|-------------|
| 1        | 1 × $7.95              | **$7.95**   |
| 2        | 2 × $7.95              | **$15.90**  |
| 3        | 3 × $7.95              | **$23.85**  |

---

### 🎁 Pricing Breakdown

- **Red Widget (R01)** applies a Buy One, Get One Half Price offer on each pair. Odd items are charged at full price.
- **Green Widget (G01)** and **Blue Widget (B01)** have no special offers, and are charged at regular prices.

> 📦 Delivery charges are applied based on subtotal thresholds.

---

## 📌 Assumptions Inferred

- 🔁 **Offers apply only in valid pairs** — any extra unit beyond the pair is full price.
- 💰 **Discounts are applied before calculating delivery charges.**
- ✂️ **Prices are truncated**, not rounded, to two decimal places (e.g., 82.375 becomes 82.37).
- 📦 **Delivery charge tiers** are:
  - Subtotal < $50 → $4.95 delivery
  - $50 ≤ Subtotal < $90 → $2.95 delivery
  - Subtotal ≥ $90 → Free delivery
- ✅ **Delivery is based on the discounted subtotal**, not the original (pre-offer) price.


---

## 🧪 Example Baskets and Expected Totals

| Basket (Product Codes)         | Total   |
|-------------------------------|---------|
| `B01, G01`                    | $37.85  |
| `R01, R01`                    | $54.37  |
| `R01, G01`                    | $60.85  |
| `B01, B01, R01, R01, R01`     | $98.27  |
