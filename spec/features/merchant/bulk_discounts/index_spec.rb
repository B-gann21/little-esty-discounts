require 'rails_helper'

RSpec.describe "A merchant's bulk discounts index page" do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Brylan')
    @discount_1 = @merchant_1.bulk_discounts.create!(name: "buy 10 get 25% off", quantity_threshold: 10, discount_percent: 25)
    @discount_1a = @merchant_1.bulk_discounts.create!(name: "buy 15 get 30% off", quantity_threshold: 15, discount_percent: 30)

    @merchant_2 = Merchant.create!(name: 'Jeffrey')
    @discount_2 = @merchant_2.bulk_discounts.create!(name: "buy 20 get 5% off", quantity_threshold: 20, discount_percent: 5)

    visit "/merchants/#{@merchant_1.id}/bulk_discounts"
  end

  context 'CRUD links' do
    it 'each bulk discount should be a link to its show page' do
      click_link("Discount #{@discount_1.id}")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@discount_1.id}")
    end

    it 'has a link to create a new discount' do
      click_link 'New Discount'

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    end

    it 'each bulk discount should have a delete link nearby' do
      expect(page).to have_content("#{@discount_1.id}")
      expect(page).to have_content("#{@discount_1a.id}")

      within "#discount-#{@discount_1.id}" do
        click_link "Delete discount"
      end

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to_not have_content("#{@discount_1.id}")
      expect(page).to have_content("#{@discount_1a.id}")

      within "#discount-#{@discount_1a.id}" do
        click_link "Delete discount"
      end

      expect(page).to_not have_content("#{@discount_1.id}")
      expect(page).to_not have_content("#{@discount_1a.id}")
    end
  end

  context 'contents' do
    it 'shows all discounts for a given merchant' do
      expect(page).to have_css("#discount-#{@discount_1.id}")
      expect(page).to have_css("#discount-#{@discount_1a.id}")
      expect(page).to_not have_css("#discount-#{@discount_2.id}")
    end

    it 'each discount has its quantity and discount percentage nearby' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount #{@discount_1.id}")
        expect(page).to_not have_content("Discount #{@discount_1a.id}")

        expect(page).to have_content("Quantity threshold: 10")
        expect(page).to have_content("Discount percentage: 25")

        expect(page).to_not have_content("Quantity threshold: 15")
        expect(page).to_not have_content("Discount percentage: 30")
      end

      within "#discount-#{@discount_1a.id}" do
        expect(page).to have_content("Discount #{@discount_1a.id}")
        expect(page).to_not have_content("Discount #{@discount_1.id}")

        expect(page).to have_content("Quantity threshold: 15")
        expect(page).to have_content("Discount percentage: 30")

        expect(page).to_not have_content("Quantity threshold: 10")
        expect(page).to_not have_content("Discount percentage: 25")
      end
    end
  end

  context 'weather info' do
    it 'has a section that displays the next 3 upcoming US holidays' do
      Timecop.freeze(2022, 4, 25)

      visit "/merchants/#{@merchant_1.id}/bulk_discounts"

      expect(page).to have_css('#next-3-holidays')

      within '#next-3-holidays' do
        expect(page).to have_css('#holiday', count: 3)
      end

      expect(page).to have_content('Name: Memorial Day')
      expect(page).to have_content('Date: 2022-05-30')

      expect(page).to have_content('Name: Juneteenth')
      expect(page).to have_content('Date: 2022-06-20')

      expect(page).to have_content('Name: Independence Day')
      expect(page).to have_content('Date: 2022-07-04')

      Timecop.return
    end
  end
end
