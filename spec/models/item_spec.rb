require 'rails_helper'

RSpec.describe Item do
  before :each do
    @merchant = Merchant.create!(name: "Frank's Pudding",
                           created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                           updated_at: Time.parse('2012-03-27 14:53:59 UTC'))

    @item = @merchant.items.create!(name: 'Chocolate Delight', unit_price: 500,
                             description: 'tastiest chocolate pudding on the east coast',
                              created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                              updated_at: Time.parse('2012-03-27 14:53:59 UTC'))
  end

  context 'readable attributes' do
    it 'has a name' do
      expect(@item.name).to eq("Chocolate Delight")
    end

    it 'has a description' do
      expect(@item.description).to eq('tastiest chocolate pudding on the east coast')
    end

    it 'has a unit price' do
      expect(@item.unit_price).to eq(500)
    end
  end

  context 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :description}
    it { should validate_presence_of :unit_price}
    it { should validate_numericality_of :unit_price}
  end

  context 'relationships' do
    it { should belong_to :merchant}
    it { should have_many(:bulk_discounts).through(:merchant)}
    it { should have_many(:invoices).through(:invoice_items)}
  end

  context 'instance methods' do
    it '.ordered-invoices should return invoices in order of created_at ascending' do
      merchant = Merchant.create!(name: 'Brylan')
      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson",
                                   created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                   updated_at: Time.parse('2012-03-27 14:54:09 UTC'))

      invoice = customer.invoices.create!(status: "in progress",
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))

      invoice2 = customer.invoices.create!(status: "in progress",
                                            created_at: Time.parse('2012-03-25 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-25 09:54:09 UTC'))

      invoice_item_1 = invoice.invoice_items.create!(item_id: item_1.id, quantity: 8, unit_price: 100, status: 'shipped')
      invoice_item_2 = invoice2.invoice_items.create!(item_id: item_1.id, quantity: 5, unit_price: 500, status: 'packaged')

      expect(item_1.ordered_invoices).to eq([invoice2, invoice])
    end

    it 'returns the date with the best sales' do
      merchant = Merchant.create!(name: 'Brylan')

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      invoice_1 = customer_1.invoices.create!(status: 'completed',
                                   created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                   updated_at: Time.parse('2012-03-27 14:54:09 UTC'))
      item_1 = merchant.items.create!(name: 'Pencil', unit_price: 1, description: 'Writes things.')
      item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 4, unit_price: 4, status: 2)
      invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')

      customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
      invoice_2 = customer_2.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))
      item_1.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 4, status: 2)
      invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')

      expect(item_1.date_with_most_sales).to eq(invoice_2.updated_at)
    end
  end
end
