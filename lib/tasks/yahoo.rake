namespace :yahoo do
  task :add_player_info => :environment do
    AddYahooPlayersJob.new.run!
  end

  task :merge_players => :environment do
    PlayerMerger.find_duplicate_players
  end

  task :add_weekly_stats => :environment do
    puts 'Adding player stats'
    i = Player.count
    Player.find_each do |player|
      i -= 1; puts i if i % 10 == 0
      1.upto(5).each do |i|
        player.weekly_stat_for_season("2017", i)
      end
      sleep 1
    end
  end
end
