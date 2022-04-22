require 'rails_helper'

RSpec.describe 'A bulk discount show page' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @discount_1 = @merchant_1.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 25)
    @discount_1a = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 30)

    @merchant_2 = Merchant.create!(name: 'Jeffrey')
    @discount_2 = @merchant_2.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 5)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}"
  end

  it 'displays info on the bulk discount' do
    expect(page).to have_content("#{@discount_1.id}")
    expect(page).to have_content("Quantity threshold: 10")
    expect(page).to have_content("Discount percentage: 25")

    expect(page).to_not have_content("#{@discount_1a.id}")
    expect(page).to_not have_content("Quantity threshold: 15")
    expect(page).to_not have_content("Discount percentage: 30")

    expect(page).to_not have_content("#{@discount_2.id}")
    expect(page).to_not have_content("Quantity threshold: 20")
    expect(page).to_not have_content("Discount percentage: 5")
  end

  context 'CRUD links' do
    it 'displays a link to edit the discount' do
      click_link('Edit Discount')

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}/edit")
    end
  end
end
