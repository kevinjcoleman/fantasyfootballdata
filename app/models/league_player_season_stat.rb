class LeaguePlayerSeasonStat < ApplicationRecord
  belongs_to :player_season
  belongs_to :league

  def self.create_from_objects(league, player_season)
    begin
      total = league.stats_for_calculations.inject(0) do |value, (k, v)|
        value += player_season.send(k) * v
      end.round(2)
      where(league_id: league.id, player_season_id: player_season.id).first_or_create.tap do |lp|
        lp.total_points = total
        lp.save!
      end
    rescue => e
      puts "There was an error adding the stats for #{player_season.id}."
    end
  end
end
