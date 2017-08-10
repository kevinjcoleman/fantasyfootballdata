class BackfillLeagueStatsJob
  attr_reader :league
  def initialize(league: league)
    @league = league
  end

  def run!
    Player.includes(:player_seasons).find_each do |player|
      player.player_seasons.each do |season|
        LeaguePlayerSeasonStat.create_from_objects(league, season)
      end
    end
  end
end
