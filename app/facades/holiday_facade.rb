class HolidayFacade
  def initialize
    @holidays = create_holidays
  end

  def create_holidays
    service.all_holidays(Date.today.year).map do |holiday_info|
      Holiday.new(holiday_info)
    end
  end

  def next_3_holidays
    upcoming_holidays = create_holidays.find_all { |holiday| holiday.date > Date.today.to_s }
    upcoming_holidays.take(3)
  end

  def service
    HolidayService.new
  end
end
