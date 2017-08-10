class League < ApplicationRecord
  has_many :teams
  has_many :league_stats, class_name: "LeaguePlayerSeasonStat"

  def stats_for_calculations
     stat_categories.inject({}) { |h, (k, v)| h[k] = v.to_f; h }
  end
end
