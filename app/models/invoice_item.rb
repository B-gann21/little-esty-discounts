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

  def total_revenue
    quantity * unit_price
  end

  def discounted_revenue
    if best_bulk_discount
      (1 - best_bulk_discount.discount_percent.to_f / 100) * (quantity * unit_price)
    else
      total_revenue
    end
  end

  def self.items_total_revenue
    sum('quantity * unit_price')
  end
end
