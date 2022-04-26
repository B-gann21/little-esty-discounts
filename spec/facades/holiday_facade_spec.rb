require 'rails_helper'

RSpec.describe HolidayFacade do
  context 'instance methods' do
    it '.service creates a HolidayService' do
      facade = HolidayFacade.new
      service = facade.service

      expect(service).to be_a(HolidayService)
    end

    it '.holidays creates POROs for each holiday' do
      Timecop.freeze(2020, 1, 2)

      facade = HolidayFacade.new
      holidays = facade.holidays

      expect(holidays).to be_a(Array)
      expect(holidays.count).to eq(12)
      expect(holidays).to be_all(Holiday)
      expect(holidays.any?(Hash)).to be(false)

      Timecop.return
    end

    it '.next_3_holidays returns 3 holiday POROs of the upcoming 3 holidays' do
      Timecop.freeze(2020, 1, 2)

      facade = HolidayFacade.new
      holidays = facade.next_3_holidays

      expect(holidays).to be_a(Array)
      expect(holidays.count).to eq(3)
      expect(holidays).to be_all(Holiday)
      expect(holidays.any?(Hash)).to be(false)

      expect(holidays[0].name).to eq('Martin Luther King Jr. Day')
      expect(holidays[1].name).to eq("Presidents day")
      expect(holidays[2].name).to eq("Good Friday")

      Timecop.return
    end
  end
end
