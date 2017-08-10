namespace :yahoo do
  task :add_player_info => :environment do
    AddYahooPlayersJob.new.run!
  end

  task :merge_players => :environment do
    PlayerMerger.find_duplicate_players
  end
end
