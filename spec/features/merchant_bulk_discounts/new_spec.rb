require 'rails_helper'
RSpec.describe 'new discount form' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @discount_1 = @merchant_1.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 25)
    @discount_1a = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 30)

    @merchant_2 = Merchant.create!(name: 'Jeffrey')
    @discount_2 = @merchant_2.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 5)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts"
  end

  it 'can create a new discount' do
    expect(page).to_not have_content('Quantity threshold: 25')
    expect(page).to_not have_content('Discount percentage: 50')
    click_link 'New Discount'

    fill_in :quantity_threshold, with: 25
    fill_in :discount_percent, with: 50
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
    expect(page).to have_content('Quantity threshold: 25')
    expect(page).to have_content('Discount percentage: 50')
  end

  context 'takes valid data only' do
    it 'fields can not be empty' do
      click_link 'New Discount'

      fill_in :discount_percent, with: 50
      click_button 'Submit'

      expect(page).to_not have_content("Brylan's bulk discounts")
      expect(page).to have_content("Notice: fields can not be empty")
      expect(page).to have_field(:discount_percent)
      expect(page).to have_field(:quantity_threshold)
    end

    it 'discount percent can not be over 100' do
      click_link 'New Discount'

      fill_in :discount_percent, with: 101
      fill_in :quantity_threshold, with: 50
      click_button 'Submit'

      expect(page).to_not have_content("Brylan's bulk discounts")
      expect(page).to have_content("Notice: discount must be between 1-100%")
      expect(page).to have_field(:discount_percent)
      expect(page).to have_field(:quantity_threshold)
    end
  end
end
