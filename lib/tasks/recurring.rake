namespace :recurring do
  task fantasy_pros: :environment do
    FantasyProsTask.schedule!
  end

  task yahoo: :environment do
    YahooWeeklyStatsTask.schedule!
  end
end
