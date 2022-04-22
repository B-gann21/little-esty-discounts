require 'rails_helper'
# Merchant Bulk Discount Create
#
# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed
RSpec.describe 'new discount form' do
  it 'can create a new discount' do
    merchant_1 = Merchant.create!(name: 'Brylan')
    discount_1 = merchant_1.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 25)
    discount_1a = merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 30)

    merchant_2 = Merchant.create!(name: 'Jeffrey')
    discount_2 = merchant_2.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 5)

    visit "/merchants/#{merchant_1.id}/bulk_discounts"

    expect(page).to_not have_content('Quantity threshold: 25')
    expect(page).to_not have_content('Discount percent: 50')
    click_link 'New Discount'

    fill_in :quantity_threshold, with: 25
    fill_in :discount_percent, with: 50
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts")
    expect(page).to have_content('Quantity threshold: 25')
    expect(page).to have_content('Discount percent: 50')
  end
end
