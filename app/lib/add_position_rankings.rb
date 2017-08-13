class AddPositionRankings
  attr_reader :league, :league_position_counts

  def initialize(league)
    @league = league
    @league_position_counts = roster_positions.slice("tight_ends", "quarterbacks", "running_backs", "wide_recievers").each_with_object({}) do |(k, v), hash|
      hash[k] = v.to_i * league.teams.count
    end
  end

  def run!
    binding.irb
  end
end
