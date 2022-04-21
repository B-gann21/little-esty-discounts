class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold
  validates_numericality_of :quantity_threshold, in: 1..100
  validates :discount_percent, presence: true, numericality: true

  belongs_to :merchant
end
