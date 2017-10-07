class LeaguePlayerSeasonStat < ApplicationRecord
  belongs_to :player_season
  belongs_to :league

  def self.create_from_objects(league, player_season)
    begin
      total = StatsCalculator.total_points(league, player_season)
      where(league_id: league.id, player_season_id: player_season.id).first_or_create.tap do |lp|
        lp.total_points = total
        lp.save!
      end
    rescue => e
      puts "There was an error adding the stats for #{player_season.id}."
    end
  end

  def update_points!
    update_attributes!(total_points: calculated_total_points)
  end

  def calculated_total_points
    self.class.calulate_points(league, player_season)
  end
end
