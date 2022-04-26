require 'rails_helper'

RSpec.describe HolidayService do
  context 'instance methods' do
    it '.get_url(url) grabs an array of hashes with symbols as keys' do
      service = HolidayService.new
      response = service.get_url('https://date.nager.at/api/v2/NextPublicHolidays/US')

      expect(response).to be_a(Array)
      expect(response).to be_all(Hash)
    end

    it '.all_holidays returns all holidays for the current year' do
      Timecop.freeze(2020, 1, 20)

      service = HolidayService.new
      holidays = service.all_holidays

      expect(holidays.count).to eq(12)
      expect(holidays).to be_all(Hash)
      expect(holidays[0][:name]).to eq("New Year's Day")
      expect(holidays[1][:name]).to eq('Martin Luther King Jr. Day')
      expect(holidays[2][:name]).to eq("President's Day")

      Timecop.return
    end
  end
end
