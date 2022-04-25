require 'rails_helper'


RSpec.describe 'Admin Invoice Show page' do
  it 'displays all of the items on the invoice' do
    merchant = Merchant.create!(name: 'Brylan')
    item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
    item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
    customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
    invoice_1 = customer.invoices.create(status: "in progress")
    invoice_2 = customer.invoices.create(status: "in progress")
    invoice_item_1 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 9, unit_price: 100, status: "packaged")
    invoice_item_2 = InvoiceItem.create(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 10, unit_price: 100, status: "packaged")

    customer_2 = Customer.create!(first_name: "Illy", last_name: "Jonson")
    invoice_3 = customer_2.invoices.create(status: "in progress")
    invoice_4 = customer_2.invoices.create(status: "in progress")
    invoice_item_3 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 10, unit_price: 100, status: "packaged")
    invoice_item_4 = InvoiceItem.create(item_id: item_2.id, invoice_id: invoice_4.id, quantity: 10, unit_price: 100, status: "packaged")

    merchant_2 = Merchant.create!(name: 'Chris')
    item_3 = merchant_2.items.create!(name: 'Ball', unit_price: 500, description: 'Fun')
    customer_3 = Customer.create!(first_name: "Illy", last_name: "Jonson")
    invoice_5 = customer_2.invoices.create(status: "in progress")
    invoice_item_5 = InvoiceItem.create(item_id: item_3.id, invoice_id: invoice_5.id, quantity: 10, unit_price: 100, status: "packaged")

    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("Item Name: Bottle")
    expect(page).to have_content("Quantity: 9")
    expect(page).to have_content("Price: 10")
    expect(page).to have_content("Status: packaged")
  end

  describe 'invoice information' do
    before(:each) do
      @merchant = Merchant.create!(name: 'Brylan')
      @merchant_2 = Merchant.create!(name: 'Chris')
      @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      @item_3 = @merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      @invoice_1 = @customer.invoices.create(status: "in progress")
      @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 2)
      @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 2)
      @item_3.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 2)
    end

    it 'lists Invoice id, status, created at and customer name' do
      visit "/admin/invoices"

      click_link "#{@invoice_1.id}"
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_1.status}")
      expect(page).to have_content("#{@invoice_1.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("Billy Jonson")
    end

    it 'lists a link to update Invoice status using a select field' do
      visit "/admin/invoices/#{@invoice_1.id}"

      select "cancelled" , from: :status
      click_button 'Change Status'
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content('cancelled')
    end

    it 'displays the total revenue for the invoice' do
      visit "/admin/invoices/#{@invoice_1.id}"
      expect(page).to have_content('Total Revenue: $36.00')
    end

    it 'shows discounted revenue' do
      merchant_1 = Merchant.create!(name: 'Brylan')
      discount_1a = merchant_1.bulk_discounts.create!(name: 'buy 5 get 15% off', quantity_threshold: 5, discount_percent: 15)
      discount_1b = merchant_1.bulk_discounts.create!(name: 'buy 10 get 25% off', quantity_threshold: 10, discount_percent: 25)
      item_1a = merchant_1.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_1b = merchant_1.items.create!(name: 'Can', unit_price: 500, description: 'Soda')

      merchant_2 = Merchant.create!(name: 'Chris')
      item_2a = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create(status: "in progress")
      invoice_item_1a = item_1a.invoice_items.create!(invoice_id: invoice_1.id, quantity: 5, unit_price: 400, status: 2)
      invoice_item_1b = item_1b.invoice_items.create!(invoice_id: invoice_1.id, quantity: 10, unit_price: 400, status: 2)
      invoice_item_1c = item_2a.invoice_items.create!(invoice_id: invoice_1.id, quantity: 5, unit_price: 400, status: 2)

      invoice_2 = customer.invoices.create!(status: 'in progress')
      invoice_item_2a = item_1a.invoice_items.create!(invoice_id: invoice_2.id, quantity: 2, unit_price: 400, status: 2) 
      invoice_item_2b = item_1b.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 400, status: 2) 
      invoice_item_2c = item_2a.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 400, status: 2) 

      visit "/admin/invoices/#{invoice_1.id}"
      expect(page).to have_content('Discounted Revenue: $67.00')
      expect(page).to_not have_content('Discounted Revenue: $80.00')
      expect(page).to_not have_content('Discounted Revenue: $64.00')

      visit "/admin/invoices/#{invoice_2.id}"
      expect(page).to have_content('Total Revenue: $40.00')
      expect(page).to_not have_content('Discounted Revenue: $40.00')
      expect(page).to_not have_content('Discounted Revenue: $37.00')
    end
  end
end
