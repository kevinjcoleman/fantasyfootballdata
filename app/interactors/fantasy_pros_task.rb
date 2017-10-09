class FantasyProsTask
  include Delayed::RecurringJob
  run_every 1.day
  run_at '1:00am'
  timezone 'US/Pacific'
  def perform
    UpdateSender.new(subject: 'Starting ffpros update',
                     text: '<p>running</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
    AddFantasyProProjections.run!
    UpdateSender.new(subject: 'Finished ffpros update',
                     text: '<p>finished 😄</p>',
                     recipients: ['kevinjamescoleman.7@gmail.com']).send!
  end
end
