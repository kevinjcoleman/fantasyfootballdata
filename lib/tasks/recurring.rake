namespace :recurring do
  task init: :environment do
    FantasyProsTask.schedule!
    YahooWeeklyStatsTask.schedule(run_every: 1.week, run_at: ['sunday 1:00pm', 'sunday 4:30pm', 'sunday 10:00pm', 'monday 10:00pm', 'thursday 10:00pm']) 
  end
end
