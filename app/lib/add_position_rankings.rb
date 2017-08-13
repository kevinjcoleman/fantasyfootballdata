class AddPositionRankings
  attr_reader :league, :league_position_counts

  def initialize(league)
    @league = league
    @league_position_counts = league.roster_positions.slice("tight_ends", "quarterbacks", "running_backs", "wide_recievers").each_with_object({}) do |(k, v), hash|
      hash[k] = v.to_i * league.teams.count
    end
  end

  POSITIONS = {'tight_ends' => "TE",
               'quarterbacks' => 'QB',
               'running_backs' => 'RB',
               'wide_recievers' => 'WR'}
  def run!
    league_position_counts.each do |position, counts|
      query = LeaguePlayerSeasonStat.joins(player_season: :player).where(players: {position: POSITIONS[position]}).order(total_points: :DESC)
      query.each_with_index do |stat, i|
        stat.update_attributes!(position_ranking: i+1)
      end
      median_points = query.where(position_ranking: counts.to_i).first.total_points
      query.find_each do |stat|
        stat.update_attributes!(point_differential: stat.total_points.to_f - median_points)
      end
    end
  end
end
