require 'rails_helper'

RSpec.describe Invoice do
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
    before :each do
      @merchant = Merchant.create!(name: 'Brylan')
      @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

      @merchant_2 = Merchant.create!(name: 'Jilly Bonson')
      @item_3 = @merchant_2.items.create!(name: 'Juice Box', unit_price: 300, description: 'Apple Juice')

      @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      @invoice = @customer.invoices.create!(status: "in progress")
      @invoice_2 = @customer.invoices.create!(status: "in progress")
      @invoice_3 = @customer.invoices.create!(status: "completed")

      @invoice_item_1 = @invoice.invoice_items.create!(item_id: @item_1.id, quantity: 8, unit_price: 100, status: 'shipped')
      @invoice_item_1a = @invoice.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'packaged')
      @invoice_item_1b = @invoice.invoice_items.create!(item_id: @item_3.id, quantity: 4, unit_price: 500, status: 'packaged')
      @invoice_item_2 = @invoice_2.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'packaged')
      @invoice_item_3 = @invoice_3.invoice_items.create!(item_id: @item_2.id, quantity: 5, unit_price: 500, status: 'shipped')
    end

    it 'has a status' do
      expect(@invoice.status).to eq("in progress")
    end

    it '.get_invoice_item(id) returns a specific invoice item' do
      expect(@invoice.get_invoice_item(@item_1.id)).to eq(@invoice_item_1)
      expect(@invoice.get_invoice_item(@item_1.id)).to be_a(InvoiceItem)

      expect(@invoice.get_invoice_item(@item_2.id)).to eq(@invoice_item_1a)
      expect(@invoice.get_invoice_item(@item_2.id)).to be_a(InvoiceItem)
    end

    it '.incomplete_invoices can return invoices with items that have not shipped' do
      expect(Invoice.incomplete_invoices).to eq([@invoice, @invoice_2])
      expect(Invoice.incomplete_invoices.count).to eq(2)

      expect(Invoice.incomplete_invoices).to_not include(@invoice_3)
    end

    it '.get_items_from_merchant(merchant_id) returns all invoice items with the given merchant_id' do
      expect(@invoice.get_items_from_merchant(@merchant.id)).to include(@invoice_item_1, @invoice_item_1a)
      expect(@invoice.get_items_from_merchant(@merchant_2.id)).to include(@invoice_item_1b)

      expect(@invoice.get_items_from_merchant(@merchant.id)).to_not include(@invoice_item_1b)
      expect(@invoice.get_items_from_merchant(@merchant_2.id)).to_not include(@invoice_item_1, @invoice_item_1a)
      expect(@invoice_2.get_items_from_merchant(@merchant_2.id)).to be_empty
      expect(@invoice_3.get_items_from_merchant(@merchant_2.id)).to be_empty
    end

    it '.revenue_for(merchant_id) returns the revenue made by a given merchant' do
      expect(@invoice.revenue_for(@merchant.id)).to eq(3300)
      expect(@invoice.revenue_for(@merchant_2.id)).to eq(2000)

      expect(@invoice.revenue_for(@merchant.id)).to_not eq(5300)
      expect(@invoice.revenue_for(@merchant_2.id)).to_not eq(3300)
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
  end

  context 'discounted revenue methods' do
    before :each do
      @merchant = Merchant.create!(name: 'Brylan')
      @merchant_2 = Merchant.create!(name: 'Chris')

      @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      @item_3 = @merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      @invoice_1 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      @invoice_2 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      @invoice_item_1a = @invoice_1.invoice_items.create!(item_id: @item_1.id, status: "shipped", quantity: 8, unit_price: 100)
      @invoice_item_1b = @invoice_1.invoice_items.create!(item_id: @item_2.id, status: "packaged", quantity: 5, unit_price: 500)
      @invoice_item_1d = @invoice_1.invoice_items.create!(item_id: @item_3.id, status: "packaged", quantity: 4, unit_price: 500)

      @discount_1 = @merchant.bulk_discounts.create!(name: "Buy 5 items, get 10% off", quantity_threshold: 5, discount_percent: 10)
      @discount_2 = @merchant.bulk_discounts.create!(name: "Buy 2 items, get 8% off", quantity_threshold: 2, discount_percent: 8)
      @invoice_item_2 = @invoice_2.invoice_items.create!(item_id: @item_3.id, quantity: 3, unit_price: 400, status: 2)
    end

    it '.orders_that_can_be_discounted_for(merchant_id) returns discounted orders for a merchant' do
      expect(@invoice_1.orders_that_can_be_discounted_for(@merchant.id)).to include(@invoice_item_1a, @invoice_item_1b)
      expect(@invoice_1.orders_that_can_be_discounted_for(@merchant.id)).to_not include(@invoice_item_1d)
    end

    it '.orders_that_can_be_discounted returns invoice_items that can qualify for a discount' do
      expect(@invoice_1.orders_that_can_be_discounted.sort).to eq([@invoice_item_1a, @invoice_item_1b].sort)
      expect(@invoice_1.orders_that_can_be_discounted).to_not include([@invoice_item_1d, @invoice_item_2])
      expect(@invoice_2.orders_that_can_be_discounted).to eq([])
    end

    it 'invoice_items in .orders_that_can_be_discounted are matched with the highest discount_percent' do
      qualified_orders_1 = @invoice_1.orders_that_can_be_discounted.sort
      invoice_item_1a = qualified_orders_1[0]
      invoice_item_1b = qualified_orders_1[1]

      expect(invoice_item_1a.best_deal).to eq(10)
      expect(invoice_item_1a.best_deal).to_not eq(8)

      expect(invoice_item_1b.best_deal).to eq(10)
      expect(invoice_item_1b.best_deal).to_not eq(8)
    end

    it '.total_discounted_revenue just returns total_revenue if no discounts are applied' do
      expect(@invoice_2.total_discounted_revenue).to eq(@invoice_2.total_revenue)
      expect(@invoice_2.total_discounted_revenue).to_not eq(1104)
    end

    it '.total_discounted_revenue returns total revenue minus applied discounts' do
      expect(@invoice_1.total_discounted_revenue).to eq(4970)
      expect(@invoice_1.total_discounted_revenue).to_not eq(5300)
    end
  end
end
