namespace :recurring
  task init: :environment do
    FantasyProsTask.schedule!
    YahooWeeklyStatsTask.schedule!
  end
end
