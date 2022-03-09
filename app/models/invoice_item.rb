class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discount_applied?
    merchant = Merchant.where('id = ?', item.merchant_id).first
    if merchant.bulk_discounts.empty?
      false
    else
      self.quantity >= merchant.bulk_discounts.minimum(:quantity_threshold)
    end
  end

  def find_bulk_discount
    merchant = Merchant.where('id = ?', item.merchant_id).first
    merchant.bulk_discounts
            .where('quantity_threshold <= ?', quantity)
            .order(percentage: :desc).first
  end
end
