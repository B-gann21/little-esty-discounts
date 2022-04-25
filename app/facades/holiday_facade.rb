class HolidayFacade
  def next_3_holidays
    service.upcoming_holidays[0..2].map do |holiday_info|
      Holiday.new(holiday_info)
    end
  end

  def service
    HolidayService.new
  end
end
