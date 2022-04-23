class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ['in progress', 'cancelled', 'completed']

  def get_invoice_item(item_id)
    invoice_items.find_by(item_id: item_id)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    discounted_orders = orders_that_can_be_discounted
    if discounted_orders.empty?
      total_revenue
    else
      calculate_discount_revenue(discounted_orders)
    end
  end

  def orders_that_can_be_discounted
    invoice_items.joins(item: {merchant: :bulk_discounts})
    .select("invoice_items.*, max(bulk_discounts.discount_percent) as best_deal")
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group(:id)
    .compact
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: 2})
    .order(:created_at)
    .distinct
  end

private
  def calculate_discount_revenue(discounted_orders)
    total = 0
    discounted_orders.each do |invoice_item|
      total += (1.0 - invoice_item.best_deal.to_f / 100) * (invoice_item.quantity * invoice_item.unit_price)
    end

    invoice_items.each do |invoice_item|
      total += invoice_item.quantity * invoice_item.unit_price if !discounted_orders.include?(invoice_item)
    end
    total.to_i
  end
end
