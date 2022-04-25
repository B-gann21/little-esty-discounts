class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates :unit_price, numericality: true
  enum status: ["disabled", "enabled"]

  belongs_to :merchant
  has_many :bulk_discounts, through: :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def ordered_invoices
    invoices.order(created_at: :asc)
            .group(:id)
  end

  def date_with_most_sales
      invoices.joins(:transactions)
              .where(transactions: {result: 'success'})
              .group(:id)
              .select("invoices.*, sum(invoice_items.quantity) as quantity")
              .order(quantity: :desc)
              .limit(1)
              .first.updated_at
  end
end
