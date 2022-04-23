require 'rails_helper'

RSpec.describe Invoice do
  before :each do
    @merchant = Merchant.create!(name: 'Brylan')
    @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
    @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
    @invoice = @customer.invoices.create!(status: "in progress")
    @invoice_2 = @customer.invoices.create!(status: "in progress")
    @invoice_3 = @customer.invoices.create!(status: "completed")

    @invoice_item_1 = @invoice.invoice_items.create!(item_id: @item_1.id, quantity: 8, unit_price: 100, status: 'shipped')
    @invoice_item_1a = @invoice.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'packaged')
    @invoice_item_2 = @invoice_2.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'packaged')
    @invoice_item_3 = @invoice_3.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'shipped')
  end

  context 'readable attributes' do
    it 'has a status' do
      expect(@invoice.status).to eq("in progress")
    end
  end

  context 'validations' do
    it { should validate_presence_of :status}
    it { should define_enum_for(:status) }
  end

  context 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  context 'instance methods' do
    it '.get_invoice_item(id) returns a specific invoice item' do
      expect(@invoice.get_invoice_item(@item_1.id)).to eq(@invoice_item_1)
      expect(@invoice.get_invoice_item(@item_1.id)).to be_a(InvoiceItem)

      expect(@invoice.get_invoice_item(@item_2.id)).to eq(@invoice_item_1a)
      expect(@invoice.get_invoice_item(@item_2.id)).to be_a(InvoiceItem)
    end

    it '.total_revenue returns the sum of all item costs' do
      merchant = Merchant.create!(name: 'Brylan')
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 3, description: 'Soda')
      item_3 = merchant.items.create!(name: 'Bowl', unit_price: 15, description: 'Soda')
      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice = customer.invoices.create(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      item_1.invoice_items.create!(invoice_id: invoice.id, quantity: 3, unit_price: 4, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice.id, quantity: 3, unit_price: 4, status: 2)
      item_3.invoice_items.create!(invoice_id: invoice.id, quantity: 3, unit_price: 4, status: 2)
      expect(invoice.total_revenue).to eq(36)
    end

    it '.discounted_revenue' do
      merchant = Merchant.create!(name: 'Brylan')
      merchant_2 = Merchant.create!(name: 'Chris')

      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_1.invoice_items.create!(item_id: item_1.id, status: "shipped", quantity: 8, unit_price: 100)
      invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 5, unit_price: 500)

      merchant.bulk_discounts.create!(quantity_threshold: 3, discount_percent: 10)
      item_1.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 2)
      item_2.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 2)
      item_3.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 2)

      expect(invoice_1.discounted_revenue).to eq(2970)
      expect(invoice_1.discounted_revenue).to_not eq(3300) #total revenue of invoice_1 without discount
      expect(invoice_1.discounted_revenue).to_not eq(3600) #total revenue of invoice_2
      expect(invoice_1.discounted_revenue).to_not eq(6900) #total revenue of invoice_2 + invoice_1
    end

    it '.incomplete_invoices can return invoices with items that have not shipped' do
      expect(Invoice.incomplete_invoices).to eq([@invoice, @invoice_2])
      expect(Invoice.incomplete_invoices.count).to eq(2)

      expect(Invoice.incomplete_invoices).to_not include(@invoice_3)
    end
  end
end
