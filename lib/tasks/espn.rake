namespace :espn do
  task :add_teams => :environment do
    AddNflTeamsJob.new.run!
  end

  task :add_players => :environment do
    AddEspnPlayersJob.new.run!
  end
end
