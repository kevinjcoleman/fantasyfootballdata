class YahooUpdateTeamsTask
  include Delayed::RecurringJob
  run_every 1.day
  run_at '11:00 pm'
  timezone 'US/Pacific'
  def perform
    UpdateSender.new(subject: 'Starting team update',
                     text: '<p>running</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
    League.find_each do |league|
      league.update_teams!
    end
    UpdateSender.new(subject: 'Finished team update',
                     text: '<p>finished 😄</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
  end
end
