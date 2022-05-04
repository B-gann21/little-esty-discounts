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

  def total_revenue_for(merchant)
    invoice_items.joins(item: :merchant)
                 .where(merchants: {id: merchant})
                 .sum { |invoice_item| invoice_item.total_revenue }
  end

  def total_invoice_revenue
    invoice_items.sum { |invoice_item| invoice_item.total_revenue }.to_i
  end

  def total_discounted_revenue
    invoice_items.sum { |invoice_item| invoice_item.discounted_revenue }.to_i
  end

  def orders_that_can_be_discounted
    invoice_items.joins(item: {merchant: :bulk_discounts})
    .select("invoice_items.*")
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
end
