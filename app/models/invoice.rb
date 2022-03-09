class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    savings = 0
    invoice_items.each do |ii|
      if ii.discount_applied? == true
        discount = ii.find_bulk_discount
        savings += (discount.percentage * ii.quantity * ii.unit_price)
      end
    end
    total_revenue - savings
  end

  def discount?
    total_revenue > discounted_revenue
  end
end
