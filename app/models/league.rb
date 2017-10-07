class League < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :team_members, through: :teams, dependent: :destroy
  has_many :players, through: :team_members, dependent: :destroy
  has_many :league_stats, class_name: "LeaguePlayerSeasonStat", dependent: :destroy
  has_many :weekly_totals, class_name: "WeeklyStatTotal", dependent: :destroy
  has_one :league_draft, dependent: :destroy

  def stats_for_calculations
     stat_categories.inject({}) { |h, (k, v)| h[k] = v.to_f; h }
  end
end
