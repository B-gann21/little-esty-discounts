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

  def get_items_from_merchant(merchant_id)
    invoice_items.joins(:merchant)
                 .where(items: {merchant_id: merchant_id})
  end

  def revenue_for(merchant_id)
    get_items_from_merchant(merchant_id).sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def discounted_revenue_for(merchant_id)
    if orders_that_can_be_discounted.empty?
      revenue_for(merchant_id)
    else
      calculate_discounted_revenue_for(merchant_id)
    end
  end

  def orders_that_can_be_discounted_for(merchant_id)
    invoice_items.joins(item: {merchant: :bulk_discounts})
    .select("invoice_items.*, max(bulk_discounts.discount_percent) as best_deal")
    .where(["invoice_items.quantity >= bulk_discounts.quantity_threshold",
            "items.merchant_id = #{merchant_id}"])
    .group(:id)
    .compact
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    if orders_that_can_be_discounted.empty?
      total_revenue
    else
      calculate_total_discounted_revenue
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
  def calculate_total_discounted_revenue
    total = 0
    orders_that_can_be_discounted.each do |invoice_item|
      total += (1.0 - invoice_item.best_deal.to_f / 100) * (invoice_item.quantity * invoice_item.unit_price)
    end

    invoice_items.each do |invoice_item|
      if !orders_that_can_be_discounted.include?(invoice_item)
        total += invoice_item.quantity * invoice_item.unit_price
      end
    end
    total.to_i
  end

  def calculate_discounted_revenue_for(merchant_id)
    total = 0
    orders_that_can_be_discounted_for(merchant_id).each do |invoice_item|
      total += (1.0 - invoice_item.best_deal.to_f / 100) * (invoice_item.quantity * invoice_item.unit_price)
    end

    get_items_from_merchant(merchant_id).each do |invoice_item|
      if !orders_that_can_be_discounted_for(merchant_id).include?(invoice_item)
        total += invoice_item.quantity * invoice_item.unit_price
      end
    end
    total.to_i
  end
end
