class SeasonParser
  attr_accessor :season
  def initialize(season)
    @season = season
  end

  def self.parse!(response)
    instance = new(ActiveSupport::HashWithIndifferentAccess.
                           new(response))
    instance.football? ? instance.parse_leagues : nil
  end

  SEASON_ATTRIBUTES = [:name]

  SEASON_ATTRIBUTES.each do |attr|
    define_method(attr) do
      season.dig attr
    end
  end

  def year
    season.dig :season
  end

  def football?
    name == 'Football'
  end

  def parse_leagues
    season.dig(:leagues, :league).each_with_object([]) do |league, array|
      next unless league.is_a?(ActiveSupport::HashWithIndifferentAccess)
      team_hash = team(league)
      league_hash = get_league(league)
      array << league_hash.merge({team: team_hash})
    end
  end

  def team(league)
    team = league.dig(:teams, :team)
    TeamParser.parse!(team)
  end

  def get_league(league)
    LeagueParser.parse!(league)
  end
end
