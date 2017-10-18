namespace :recurring do
  task fantasy_pros: :environment do
    FantasyProsTask.schedule!
  end

  task yahoo: :environment do
    YahooWeeklyStatsTask.schedule!(run_every: 1.week, run_at: ['sunday 1:00pm', 'sunday 4:30pm', 'sunday 10:00pm', 'monday 10:00pm', 'thursday 10:00pm']) 
    YahooUpdateTeamsTask.schedule!
  end
  task :init => [ :yahoo, :fantasy_pros ]
end
