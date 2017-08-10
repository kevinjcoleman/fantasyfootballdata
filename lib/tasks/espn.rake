namespace :espn do
  task :add_teams => :environment do
    AddNflTeamsJob.new.run!
  end

  task :add_players => :environment do
    AddEspnPlayersJob.new.run!
  end

  task :add_player_stats => :environment do
    count = Player.count
    Player.find_each do |player|
      count -= 1; p count if count % 50 == 0
      player.backfill_stats
      sleep(1)
    end
  end
end
