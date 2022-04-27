require 'rails_helper'

RSpec.describe InvoiceItem do
  before :each do
    @merchant = Merchant.create!(name: "Frank's Pudding")

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")

    @invoice = @customer.invoices.create!(status: 'in progress')

    @item = @merchant.items.create!(name: 'Chocolate Delight', unit_price: 500,
                             description: 'tastiest chocolate pudding on the east coast')

    @item_2 = @merchant.items.create!(name: 'Chocolate Delight', unit_price: 500,
                               description: 'tastiest chocolate pudding on the east coast')

    @invoice_item = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item.id,
                                            status: 'packaged', quantity: 9, unit_price: 13232)

    @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id,
                                            status: 'shipped', quantity: 9, unit_price: 0)
  end

  context 'readable attributes' do
    it 'has a status' do
      expect(@invoice_item.status).to eq('packaged')
    end
  end

 context 'validations' do
   it { should validate_presence_of :quantity }
   it { should validate_numericality_of :quantity }

   it { should validate_presence_of :unit_price }
   it { should validate_numericality_of :unit_price}

   it { should validate_presence_of :status }
   it { should define_enum_for(:status) }
 end

  context 'relationships' do
    it { should belong_to :item}
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
    it { should belong_to :invoice}
  end

  describe 'instance methods' do
    it '.best_bulk_discount returns the best bulk discount that an invoice item qualifies for' do
      merchant = Merchant.create!(name: 'Brylan')
      merchant_2 = Merchant.create!(name: 'Chris')

      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_item_1a = invoice_1.invoice_items.create!(item_id: item_1.id, status: "shipped", quantity: 8, unit_price: 100)
      invoice_item_1b = invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 10, unit_price: 500)
      invoice_item_1c = invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 4, unit_price: 500)
      invoice_item_1d = invoice_1.invoice_items.create!(item_id: item_3.id, status: "packaged", quantity: 4, unit_price: 500)

      discount_1 = merchant.bulk_discounts.create!(name: "buy 10 items, get 15% off", quantity_threshold: 10, discount_percent: 15)
      discount_1a = merchant.bulk_discounts.create!(name: "Buy 5 items, get 10% off", quantity_threshold: 5, discount_percent: 10)
      discount_1b = merchant.bulk_discounts.create!(name: "Buy 2 items, get 8% off", quantity_threshold: 2, discount_percent: 8)

      invoice_item_2 = invoice_2.invoice_items.create!(item_id: item_3.id, quantity: 3, unit_price: 400, status: 2)

      expect(invoice_item_1a.best_bulk_discount).to be_a(BulkDiscount)
      expect(invoice_item_1a.best_bulk_discount).to_not be_a(Array)

      expect(invoice_item_1a.best_bulk_discount.quantity_threshold).to eq(5)
      expect(invoice_item_1a.best_bulk_discount.quantity_threshold).to_not eq(2)

      expect(invoice_item_1a.best_bulk_discount.discount_percent).to eq(10)
      expect(invoice_item_1a.best_bulk_discount.discount_percent).to_not eq(8)

      expect(invoice_item_1b.best_bulk_discount.quantity_threshold).to eq(10)
      expect(invoice_item_1b.best_bulk_discount.quantity_threshold).to_not eq(5)
      expect(invoice_item_1b.best_bulk_discount.quantity_threshold).to_not eq(2)
    end

    it '.total_revenue returns the total revenue of quantity * unit_price' do
      merchant = Merchant.create!(name: 'Brylan')
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

      merchant_2 = Merchant.create!(name: 'Chris')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))

      invoice_item_1a = invoice_1.invoice_items.create!(item_id: item_1.id, quantity: 3, unit_price: 500, status: 'packaged')
      invoice_item_1b = invoice_1.invoice_items.create!(item_id: item_2.id, quantity: 4, unit_price: 500, status: 'packaged')

      expect(invoice_item_1a.total_revenue).to eq(1500)
      expect(invoice_item_1a.total_revenue).to_not eq(2000)

      expect(invoice_item_1b.total_revenue).to eq(2000)
      expect(invoice_item_1b.total_revenue).to_not eq(1500)
    end

    it '.discounted_revenue applies the discount_percent of the best_bulk_discount' do
      merchant = Merchant.create!(name: 'Brylan')
      discount_1 = merchant.bulk_discounts.create!(name: 'Bulk Sale', quantity_threshold: 4, discount_percent: 20)
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

      merchant_2 = Merchant.create!(name: 'Chris')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))

      invoice_item_1a = invoice_1.invoice_items.create!(item_id: item_1.id, quantity: 3, unit_price: 500, status: 'packaged')
      invoice_item_1b = invoice_1.invoice_items.create!(item_id: item_2.id, quantity: 4, unit_price: 500, status: 'packaged')

      expect(invoice_item_1a.discounted_revenue).to eq(1500)
      expect(invoice_item_1a.discounted_revenue).to_not eq(1200)

      expect(invoice_item_1b.discounted_revenue).to eq(1600)
      expect(invoice_item_1b.discounted_revenue).to_not eq(2000)
    end
  end

  describe 'class methods' do
    it 'can calculate the items total revenue' do
      expect(InvoiceItem.items_total_revenue).to eq(119088)
    end
  end
end
