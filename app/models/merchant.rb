class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  enum status: ["disabled", "enabled"]

  def top_five_customers
    customers.select("customers.*, count(transactions) as transaction_count")
             .joins(invoices: :transactions)
             .where(transactions: {result: 'success'})
             .group(:id).order(transaction_count: :desc)
             .limit(5)
  end

  def top_five_items_by_revenue
         items.joins(invoice_items: :transactions)
              .where(transactions: {result: '0'})
              .group(:id)
              .select("items.*, sum(quantity * invoice_items.unit_price) as total_revenue")
              .order(total_revenue: :desc)
              .limit(5)
  end

  def items_ready_to_ship
    items.joins(:invoices).select('items.*')
         .where("invoice_items.status = 1")
         .group("items.id")
         .distinct
         .order(:created_at)
  end

  def self.top_five
    joins(invoice_items: :transactions)
    .select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue")
    .where(transactions: {result: 'success'})
    .group(:id)
    .order(total_revenue: :desc)
    .limit(5)
  end
end
