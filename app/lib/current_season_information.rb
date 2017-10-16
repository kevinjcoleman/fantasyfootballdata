module CurrentSeasonInformation
  FIRST_MONDAY_GAME = Date.new(2017, 9, 11)

  def self.current_season
    2017
  end

  def self.current_week
    if FIRST_MONDAY_GAME > Date.today
      1
    else
      rounded_up_fraction_of_weeks = ((Date.today - FIRST_MONDAY_GAME).to_f / 7).ceil
      if rounded_up_fraction_of_weeks > 17
        UpdateSender.new(subject: 'TURN OFF JOBS FOR FFMOFO',
                         text: '<p>‼️ ‼️ ‼️ ‼️ ‼️ ‼️</p>',
                         recipients: ['kevinjamescoleman.7@gmail.com']).send!
        raise 'Past date of season, time to turn jobs off.'
      else
        1 + rounded_up_fraction_of_weeks
      end
    end
  end
end
