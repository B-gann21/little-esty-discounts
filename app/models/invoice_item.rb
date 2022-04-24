class InvoiceItem < ApplicationRecord
  validates_presence_of :status, :quantity, :unit_price

  validates :quantity, numericality: true
  validates :unit_price, numericality: true

  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  belongs_to :invoice
  has_many :transactions, through: :invoice

  enum status: ['pending', 'packaged', 'shipped']

  def best_bulk_discount
    bulk_discounts.where("#{self.quantity} >= quantity_threshold")
                  .select("bulk_discounts.*")
                  .group("bulk_discounts.id, merchants.id, items.id")
                  .order(discount_percent: :desc)
                  .first
  end

  def self.items_total_revenue
    sum('quantity * unit_price')
  end
end
