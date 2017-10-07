module StatsCalculator
  def self.total_points(league,stats)
    league.stats_for_calculations.inject(0) do |value, (k, v)|
      value += stats.send(k) * v
    end.round(2)
  end
end
