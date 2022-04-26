class HolidayFacade
  def initialize
    @holidays = create_holidays
  end

  def create_holidays
    service.all_holidays(Date.today.year).map do |holiday_info|
      Holiday.new(holiday_info)
    end
  end

  def all_dates
    @holidays.map { |holiday| holiday.name}
  end

  def service
    HolidayService.new
  end
end
