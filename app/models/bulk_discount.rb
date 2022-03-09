class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage, :quantity_threshold
  belongs_to :merchant
end