class PlayerSeason < ApplicationRecord
  belongs_to :player
  has_many :league_stats, class_name: 'LeaguePlayerSeasonStat'
  validates :season, format: { with: /\d{4}/,
    message: "must be a 4 digit year" }
  validates :passing_completions, numericality: { only_integer: true }
  validates :passing_attempts, numericality: { only_integer: true }
  validates :passing_yards, numericality: { only_integer: true }
  validates :passing_touchdowns, numericality: { only_integer: true }
  validates :passing_interceptions, numericality: { only_integer: true }
  validates :passing_qbr, numericality: true
  validates :passing_rating, numericality: true
  validates :rushing_attempts, numericality: { only_integer: true }
  validates :rushing_yards, numericality: { only_integer: true }
  validates :rushing_touchdowns, numericality: { only_integer: true }
  validates :receptions, numericality: { only_integer: true }
  validates :receiving_yards, numericality: { only_integer: true }
  validates :receiving_touchdowns, numericality: { only_integer: true }
  validates :fumbles, numericality: { only_integer: true }
  validates :fumbles_lost, numericality: { only_integer: true } 
end
