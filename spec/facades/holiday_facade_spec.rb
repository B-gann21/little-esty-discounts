require 'rails_helper'

RSpec.describe HolidayFacade do
  context 'instance methods' do
    it '.service creates a HolidayService' do
      facade = HolidayFacade.new
      service = facade.service

      expect(service).to be_a(HolidayService)
    end

    it '.next_3_holidays returns 3 holiday POROs of the upcoming 3 holidays' do
      Timecop.freeze(2022, 4, 25)

      facade = HolidayFacade.new
      holidays = facade.next_3_holidays

      expect(holidays).to be_a(Array)
      expect(holidays.count).to eq(3)
      expect(holidays.all?(Holiday)).to be(true)
      expect(holidays.any?(Hash)).to be(false)

      Timecop.return
    end
  end
end
