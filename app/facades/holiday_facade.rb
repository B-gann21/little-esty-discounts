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
    upcoming_holidays = @holidays.find_all { |holiday| holiday.date > Date.today.to_s }
    upcoming_holidays << @holidays[0..2] if upcoming_holidays.count < 3
    upcoming_holidays.flatten.take(3)
  end

  def service
    HolidayService.new
  end
end
