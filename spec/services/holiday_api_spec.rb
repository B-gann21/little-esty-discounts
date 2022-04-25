require 'rails_helper'

RSpec.describe HolidayService do
  context 'instance methods' do
    it '.get_url(url) grabs an array of hashes with symbols as keys' do
      service = HolidayService.new
      response = service.get_url('https://date.nager.at/api/v2/NextPublicHolidays/US')
      keys = response.map { |holiday| holiday.keys }.flatten

      expect(response).to be_a(Array)
      expect(response[0]).to be_a(Hash)
      expect(keys.all?(Symbol)).to be(true)
    end

    it '.upcoming_holidays lists the upcoming US holidays from the current date' do
      Timecop.freeze(2022, 4, 25)

      service = HolidayService.new
      holidays = service.upcoming_holidays

      expect(holidays[0][:name]).to eq('Memorial Day')
      expect(holidays[1][:name]).to eq('Juneteenth')
      expect(holidays[2][:name]).to eq('Independence Day')

      Timecop.return
    end
  end
end
