class LeagueLoader
  attr_accessor :league, :user, :results

  def initialize(league, user)
    @league, @user = league, user
    return nil unless need_for_update?
    @results = fetch_metadata
    league.update_attributes(roster_positions: roster_positions, stat_categories: total_stats) unless roster_positions == league.roster_positions && total_stats == league.stat_categories
    add_teams
    BackfillLeagueStatsJob.new(league: league).run! unless league.league_stats.count == PlayerSeason.count
  end

  def fetch_metadata
    user.client.league_settings(league.league_key)
  end

  def settings
    results.dig("fantasy_content", "league", "settings")
  end

  def need_for_update?
    !league.teams.where("date(updated_at) = ?", Date.today).count == league.teams.count || league.teams.count < 1
  end

  def add_teams
    LeagueTeamLoader.new(league, user).teams.each do |team|
      league.teams.where(team_key: team.team_key).first_or_create.tap do |tm|
        tm.name = team.name
        tm.logo_url = team.logo_url
        tm.url = team.url
        tm.owner = User.where(uid: team.manager_key).first_or_create.tap do |u|
          u.name = team.nickname
          u.save!
        end
        tm.save!
      end
    end
  end

  ROSTER_POSITIONS_KEY = {"QB" => 'quarterbacks',
   "WR" => 'wide_recievers',
   "RB" => 'running_backs',
   "TE" => 'tight_ends',
   "W/R/T" => 'flex',
   "K" => 'kickers',
   "DEF" => 'defenses',
   "BN" => 'bench'}

  def roster_positions
    settings.dig("roster_positions", "roster_position").each_with_object({}) do |r, positions|
      key = ROSTER_POSITIONS_KEY[r.fetch('position')]
      positions[key] = r.fetch('count').to_i
    end.symbolize_keys
  end

 ALLOWED_STAT_TYPES = {"Passing Yards"=> "passing_yards",
                       "Passing Touchdowns"=> "passing_touchdowns",
                       "Interceptions"=> "passing_interceptions",
                       "Rushing Yards"=> "rushing_yards",
                       "Rushing Touchdowns"=> "rushing_touchdowns",
                       "Receptions"=> "receptions",
                       "Receiving Yards"=> "receiving_yards",
                       "Receiving Touchdowns" => "receiving_touchdowns",
                       "Fumbles Lost"=> "fumbles_lost" }

  def total_stats
    stats = {}
    stat_categories.select {|stat_id, _| stat_id.in?(stat_modifiers.keys) }.each do |stat_id, stat|
      next unless stat['name'].in?(ALLOWED_STAT_TYPES.keys)
      modifier_value = stat_modifiers[stat_id]['value'].to_f
      stats[ALLOWED_STAT_TYPES[stat['name']]] = modifier_value
    end
    stats
  end

  def stat_categories
    settings.dig("stat_categories", "stats", "stat").each_with_object({}) do |stat, hash|
      hash[stat["stat_id"]] = stat
    end
  end

  def stat_modifiers
    settings.dig("stat_modifiers", "stats", "stat").each_with_object({}) do |stat, hash|
      hash[stat["stat_id"]] = stat
    end
  end
end
