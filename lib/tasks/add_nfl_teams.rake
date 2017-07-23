namespace :jobs do
  task :add_nfl_teams => :environment do
    AddNflTeamsJob.new.run!
  end
end
