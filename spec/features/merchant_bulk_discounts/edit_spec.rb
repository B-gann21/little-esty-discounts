require 'rails_helper'

RSpec.describe 'the edit discount form' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @discount_1 = @merchant_1.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 25)
    @discount_1a = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 30)

    @merchant_2 = Merchant.create!(name: 'Jeffrey')
    @discount_2 = @merchant_2.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 5)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit"
  end

  it 'starts prepopulated with the discount information' do
    expect(page).to have_field(:quantity_threshold, with: '10')
    expect(page).to have_field(:discount_percent, with: '25')
    expect(page).to_not have_field(:quantity_threshold, with: '15')
    expect(page).to_not have_field(:discount_percent, with: '30')
  end

  it 'can edit a discount' do
    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"
    expect(page).to have_content("Quantity threshold: 10")
    expect(page).to_not have_content("Quantity threshold: 15")

    click_link "Edit Discount"
    fill_in :quantity_threshold, with: '15'
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}")
    expect(page).to_not have_content("Quantity threshold: 10")
    expect(page).to have_content("Quantity threshold: 15")
  end

  context 'takes valid data only' do
    it 'fields can not be empty' do
      fill_in :quantity_threshold, with: ''
      click_button 'Submit'

      expect(page).to_not have_content("Bulk discount ##{@discount_1.id}")
      expect(page).to have_content("Notice: fields can not be empty")
      expect(page).to have_field(:discount_percent)
      expect(page).to have_field(:quantity_threshold)
    end

    it 'discount percent must be within 1-100%' do
      fill_in :discount_percent, with: 101
      click_button 'Submit'

      expect(page).to_not have_content("Bulk discount ##{@discount_1.id}")
      expect(page).to have_content("Notice: discount must be between 1-100%")
      expect(page).to have_field(:discount_percent)
      expect(page).to have_field(:quantity_threshold)
    end
  end
end
