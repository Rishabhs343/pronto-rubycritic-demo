# frozen_string_literal: true

# Demonstrates: FeatureEnvy — OrderProcessor touches customer more than self.
class OrderProcessor
  def calculate_total(customer)
    base     = customer.base_price
    tax      = customer.tax_amount
    shipping = customer.shipping_cost
    discount = customer.discount_value
    tip      = customer.tip_amount
    base + tax + shipping + discount + tip
  end
end
