class YahooWeeklyStatsTask
  include Delayed::RecurringJob
  run_every 1.day
  run_at '1:00 pm'
  timezone 'US/Pacific'
  def perform
    UpdateSender.new(subject: 'Starting yahoo update',
                     text: '<p>running</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
    Player.find_each {|player| player.weekly_stat_for_season(CurrentSeasonInformation.current_season, CurrentSeasonInformation.current_week)}
    UpdateSender.new(subject: 'Finished yahoo update',
                     text: '<p>finished 😄</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
  end
end
