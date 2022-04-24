require 'rails_helper'

RSpec.describe 'merchant invoice show page' do
  before(:each) do
    @merchant = Merchant.create!(name: 'Brylan')
    @merchant_2 = Merchant.create!(name: 'Chris')

    @item_1 = @merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
    @item_2 = @merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
    @item_3 = @merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
    @invoice_1 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
    @invoice_2 = @customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
    @invoice_1.invoice_items.create!(item_id: @item_1.id, status: "shipped", quantity: 8, unit_price: 100)
    @invoice_1.invoice_items.create!(item_id: @item_2.id, status: "packaged", quantity: 5, unit_price: 500)

    visit "/merchants/#{@merchant.id}/invoices/#{@invoice_1.id}"
  end

  it "displays information related to the invoice" do
    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content("in progress")
    expect(page).to have_content("Tuesday, April 12, 2022")
    expect(page).to have_content("Billy")
    expect(page).to have_content("Jonson")
  end


  context 'invoice items' do
    it 'should show the names of all items related to the invoice' do
      expect(page).to have_content("Bottle")
      expect(page).to have_content("Can")
      expect(page).to_not have_content("Jar")
    end

    it 'next to each item should be its quantity, price, and invoice_item status' do
      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Quantity: 8")
        expect(page).to have_content("Price per Item: $1.00")
        expect(page).to have_content("Status: shipped")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Price per Item: $5.00")
        expect(page).to have_content("Status: packaged")
      end
    end

    it "displays the total revenue for all items on the invoice" do
      expect(page).to have_content("Total Revenue: $33.00")
    end

    it 'displays a select box to change an invoice_item status' do
      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Status: shipped")
      end

      within "#item-#{@item_1.id}" do
        select 'packaged', from: 'select_status'
        click_button "Update Item Status"
      end

      expect(current_path).to eq("/merchants/#{@merchant.id}/invoices/#{@invoice_1.id}")

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Status: packaged")
      end
    end

    it 'if qualified for discount, an item has a link to its discount show page' do
      merchant = Merchant.create!(name: 'Brylan')
      discount_1 = merchant.bulk_discounts.create!(name: "buy 10 items, get 15% off", quantity_threshold: 10, discount_percent: 15)
      discount_1a = merchant.bulk_discounts.create!(name: "Buy 5 items, get 10% off", quantity_threshold: 5, discount_percent: 10)
      discount_1b = merchant.bulk_discounts.create!(name: "Buy 2 items, get 8% off", quantity_threshold: 2, discount_percent: 8)

      merchant_2 = Merchant.create!(name: 'Chris')

      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_item_1a = invoice_1.invoice_items.create!(item_id: item_1.id, status: "shipped", quantity: 8, unit_price: 100)
      invoice_item_1b = invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 10, unit_price: 500)
      invoice_item_1d = invoice_1.invoice_items.create!(item_id: item_3.id, status: "packaged", quantity: 4, unit_price: 500)

      invoice_item_2 = invoice_2.invoice_items.create!(item_id: item_3.id, quantity: 3, unit_price: 400, status: 2)

      visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

      within "#item-#{item_1.id}" do
        click_link "#{discount_1a.name}"
        expect(current_path).to eq("/merchants/#{merchant.id}/bulk_discounts/#{discount_1a.id}")
      end

      visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

      within "#item-#{item_2.id}" do
        expect(page).to_not have_link("#{discount_1a.name}")
        expect(page).to have_link("#{discount_1.name}")
      end
    end

    it 'displays the discounted revenue next to the total revenue' do
      merchant = Merchant.create!(name: 'Brylan')
      merchant_2 = Merchant.create!(name: 'Chris')

      item_1 = merchant.items.create!(name: 'Bottle', unit_price: 100, description: 'H20')
      item_2 = merchant.items.create!(name: 'Can', unit_price: 500, description: 'Soda')
      item_3 = merchant_2.items.create!(name: 'Jar', unit_price: 400, description: 'Jelly')

      customer = Customer.create!(first_name: "Billy", last_name: "Jonson")
      invoice_1 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_2 = customer.invoices.create!(status: "in progress", created_at: Time.parse("2022-04-12 09:54:09"))
      invoice_item_1a = invoice_1.invoice_items.create!(item_id: item_1.id, status: "shipped", quantity: 8, unit_price: 100)
      invoice_item_1b = invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 5, unit_price: 500)
      invoice_item_1c = invoice_1.invoice_items.create!(item_id: item_2.id, status: "packaged", quantity: 4, unit_price: 500)
      invoice_item_1d = invoice_1.invoice_items.create!(item_id: item_3.id, status: "packaged", quantity: 4, unit_price: 500)

      merchant.bulk_discounts.create!(name: "Buy 5 items, get 10% off", quantity_threshold: 5, discount_percent: 10)
      merchant.bulk_discounts.create!(name: "buy 2 items, get 8 % off", quantity_threshold: 2, discount_percent: 8)
      invoice_item_2 = invoice_2.invoice_items.create!(item_id: item_3.id, quantity: 3, unit_price: 400, status: 2)

      visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"
      within '#revenue' do
        expect(page).to have_content("Total Revenue: $73.00")
        expect(page).to_not have_content("Total Revenue: $12.00") #total revenue for invoice_2
        expect(page).to_not have_content("Total Revenue: $85.00") #total revenue for invoice_1 + invoice_2
        expect(page).to_not have_content("Total Revenue: $68.10")
        expect(page).to have_content("Discounted Revenue: $68.10")
      end
    end
  end
end
