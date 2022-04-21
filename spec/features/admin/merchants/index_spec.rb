require 'rails_helper'


RSpec.describe 'Admin Merchant Index' do
  describe 'Admin Merchant Index Page' do
    it 'lists each merchant in the system' do
      merchant_1 = Merchant.create!(name: 'Brylan', status: 1)
      merchant_2 = Merchant.create!(name: 'Antonio', status: 1)
      merchant_3 = Merchant.create!(name: 'Chris', status: 1)
      merchant_4 = Merchant.create!(name: 'Craig', status: 1)

      visit "/admin/merchants"
      expect(page).to have_content('Brylan')
      expect(page).to have_content('Antonio')
      expect(page).to have_content('Chris')
      expect(page).to have_content('Craig')

    end

    it 'has link to each merchant show page by clicking name' do
      merchant_1 = Merchant.create!(name: 'Brylan', status: 1)
      visit "/admin/merchants"
      click_link "Brylan"
      expect(current_path).to eq("/admin/merchants/#{merchant_1.id}")
    end

    describe 'top_5_merchants' do
      it 'has a top_5_merchants section' do
        #for simplicity, this customer will be creating all of the invoices.
        customer = Customer.create!(first_name: 'Ralph', last_name: 'Jones')

        #merchant_1 total revenue: $25.00
        merchant_1 = Merchant.create!(name: 'Brylan')
        item_1 = merchant_1.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
        invoice_1 = customer.invoices.create!(status: 'completed')
        invoice_1.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_1.invoice_items.create!(item_id: item_1.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_2 total revenue: $50.00
        merchant_2 = Merchant.create!(name: 'Chris')
        item_2 = merchant_2.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_2 = customer.invoices.create!(status: 'completed')
        invoice_2a = customer.invoices.create!(status: 'completed')
        invoice_2.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_2a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_2.invoice_items.create!(item_id: item_2.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_2a.invoice_items.create!(item_id: item_2.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_3 total revenue: $75.00
        merchant_3 = Merchant.create!(name: 'Antonio')
        item_3 = merchant_3.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_3 = customer.invoices.create!(status: 'completed')
        invoice_3a = customer.invoices.create!(status: 'completed')
        invoice_3b = customer.invoices.create!(status: 'completed')
        invoice_3.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_3a.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_3b.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_4 total revenue: $100.00
        merchant_4 = Merchant.create!(name: 'Craig')
        item_4 = merchant_4.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_4 = customer.invoices.create!(status: 'completed')
        invoice_4a = customer.invoices.create!(status: 'completed')
        invoice_4b = customer.invoices.create!(status: 'completed')
        invoice_4c = customer.invoices.create!(status: 'completed')
        invoice_4.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4c.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4a.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4b.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4c.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_5 total revenue: $125.00
        merchant_5 = Merchant.create!(name: 'Hubert')
        item_5 = merchant_5.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_5 = customer.invoices.create!(status: 'completed')
        invoice_5a = customer.invoices.create!(status: 'completed')
        invoice_5b = customer.invoices.create!(status: 'completed')
        invoice_5c = customer.invoices.create!(status: 'completed')
        invoice_5d = customer.invoices.create!(status: 'completed')
        invoice_5.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5c.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5d.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5a.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5b.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5c.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5d.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')

        #this merchant has a failed transaction, 0 revenue
        merchant_failed = Merchant.create!(name: 'Chungus')
        item_6 = merchant_failed.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
        invoice_6 = customer.invoices.create!(status: 'completed')
        invoice_6.transactions.create!(credit_card_number: '898989', result: 'failed')
        invoice_6.invoice_items.create!(item_id: item_6.id, unit_price: 500, quantity: 5, status: 'packaged')

        visit '/admin/merchants'

        within '#top_5_merchants' do
          expect(page).to_not have_content('Chungus')
          expect('Hubert').to appear_before('Craig')
          expect('Craig').to appear_before('Antonio')
          expect('Antonio').to appear_before('Chris')
          expect('Chris').to appear_before('Brylan')
        end
      end

      it 'displays the total revenue generated next to each merchant name' do
        #for simplicity, this customer will be creating all of the invoices.
        customer = Customer.create!(first_name: 'Ralph', last_name: 'Jones')

        #merchant_1 total revenue: $25.00
        merchant_1 = Merchant.create!(name: 'Brylan')
        item_1 = merchant_1.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
        invoice_1 = customer.invoices.create!(status: 'completed')
        invoice_1.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_1.invoice_items.create!(item_id: item_1.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_2 total revenue: $50.00
        merchant_2 = Merchant.create!(name: 'Chris')
        item_2 = merchant_2.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_2 = customer.invoices.create!(status: 'completed')
        invoice_2a = customer.invoices.create!(status: 'completed')
        invoice_2.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_2a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_2.invoice_items.create!(item_id: item_2.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_2a.invoice_items.create!(item_id: item_2.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_3 total revenue: $75.00
        merchant_3 = Merchant.create!(name: 'Antonio')
        item_3 = merchant_3.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_3 = customer.invoices.create!(status: 'completed')
        invoice_3a = customer.invoices.create!(status: 'completed')
        invoice_3b = customer.invoices.create!(status: 'completed')
        invoice_3.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_3.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_3a.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_3b.invoice_items.create!(item_id: item_3.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_4 total revenue: $100.00
        merchant_4 = Merchant.create!(name: 'Craig')
        item_4 = merchant_4.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_4 = customer.invoices.create!(status: 'completed')
        invoice_4a = customer.invoices.create!(status: 'completed')
        invoice_4b = customer.invoices.create!(status: 'completed')
        invoice_4c = customer.invoices.create!(status: 'completed')
        invoice_4.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4c.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_4.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4a.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4b.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_4c.invoice_items.create!(item_id: item_4.id, unit_price: 500, quantity: 5, status: 'shipped')

        #merchant_5 total revenue: $125.00
        merchant_5 = Merchant.create!(name: 'Hubert')
        item_5 = merchant_5.items.create!(name: 'Marker', unit_price: 500, description: 'Writes things, but dark, and thicc.')
        invoice_5 = customer.invoices.create!(status: 'completed')
        invoice_5a = customer.invoices.create!(status: 'completed')
        invoice_5b = customer.invoices.create!(status: 'completed')
        invoice_5c = customer.invoices.create!(status: 'completed')
        invoice_5d = customer.invoices.create!(status: 'completed')
        invoice_5.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5a.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5b.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5c.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5d.transactions.create!(credit_card_number: '898989', result: 'success')
        invoice_5.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5a.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5b.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5c.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')
        invoice_5d.invoice_items.create!(item_id: item_5.id, unit_price: 500, quantity: 5, status: 'shipped')

        #this merchant has a failed transaction, 0 revenue
        merchant_failed = Merchant.create!(name: 'Chungus')
        item_6 = merchant_failed.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
        invoice_6 = customer.invoices.create!(status: 'completed')
        invoice_6.transactions.create!(credit_card_number: '898989', result: 'failed')
        invoice_6.invoice_items.create!(item_id: item_6.id, unit_price: 500, quantity: 5, status: 'packaged')

        visit '/admin/merchants'

        within "#merchant-#{merchant_1.id}" do
          expect(page).to have_content("Total Revenue: $25.00")
        end

        within "#merchant-#{merchant_2.id}" do
          expect(page).to have_content("Total Revenue: $50.00")
        end

        within "#merchant-#{merchant_3.id}" do
          expect(page).to have_content("Total Revenue: $75.00")
        end

        within "#merchant-#{merchant_4.id}" do
          expect(page).to have_content("Total Revenue: $100.00")
        end

        within "#merchant-#{merchant_5.id}" do
          expect(page).to have_content("Total Revenue: $125.00")
        end
      end

      it 'displays a disable or enable button' do
        merchant = Merchant.create!(name: 'Yeti', status: 'enabled')
        merchant_2 = Merchant.create!(name: 'Hydroflask', status: 'enabled')
        item_1 = merchant.items.create!(name: 'Bottle', unit_price: 10, description: 'H20')
        item_4 = merchant_2.items.create!(name: 'Kettle', unit_price: 20, description: 'Tea')
        visit '/admin/merchants'
        within "#merchants-#{merchant.id}" do
          expect(page).to have_button("Disable #{merchant.name}")
          expect(page).to have_content("available")
          click_button "Disable #{merchant.name}"
          expect(current_path).to eq('/admin/merchants')
          expect(page).to have_content("unavailable")
          click_button "Enable #{merchant.name}"
          expect(page).to have_content("available")
        end

        within "#merchants-#{merchant_2.id}" do
          expect(page).to have_button("Disable #{merchant_2.name}")
          expect(page).to have_content("available")
          click_button "Disable #{merchant_2.name}"
          expect(current_path).to eq('/admin/merchants')
          expect(page).to have_content("unavailable")
          click_button "Enable #{merchant_2.name}"
          expect(page).to have_content("available")
        end
      end

      it "has sections for enabled/disbaled merchants" do
        merchant_1 = Merchant.create!(name: 'Brylan', status: 0)
        merchant_2 = Merchant.create!(name: 'Antonio', status: 0)
        merchant_3 = Merchant.create!(name: 'Chris', status: 1)
        merchant_4 = Merchant.create!(name: 'Craig', status: 1)

        visit "/admin/merchants"
        within "#merchant-enabled" do
          expect(page).to have_content("Enabled Merchants")
          expect(page).to have_content("Chris")
          expect(page).to have_content("Craig")
        end

        within "#merchant-disabled" do
          expect(page).to have_content("Disabled Merchants")
          expect(page).to have_content("Antonio")
          expect(page).to have_content("Brylan")
        end

        expect(merchant_4.name).to appear_before(merchant_1.name)
        expect(merchant_3.name).to appear_before(merchant_2.name)
      end

      it 'I see a link to create a new merchant' do

        visit "/admin/merchants"
        expect(page).to have_link("Create a New Merchant")
        click_link "Create a New Merchant"
        expect(current_path).to eq("/admin/merchants/new")
      end
    end
  end
end
