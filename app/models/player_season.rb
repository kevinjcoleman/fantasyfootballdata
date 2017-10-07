require 'yahoo/yahoo_api'

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

  def update_from_yahoo(user=User.first)
    begin
      yahoo_stat_hash(User.first.client.
                           get("#{YahooApi::BASE}/player/#{player.yahoo_key}/stats;type=season;season=#{season}")).
                           select {|hsh| hsh['stat_id'].in?(YahooStatId.accepted_ids)}.each do |stat|
        add_stat(stat)
      end
      save!
      league_stats.find_each(&:update_points!)
    rescue => e
      puts e.message
    end
  end

  def yahoo_stat_hash(response)
    response.dig('fantasy_content', 'player', 'player_stats', 'stats', 'stat')
  end

  def add_stat(stat)
    attribute = YahooStatId.name_from_stat_id(stat['stat_id'])
    send("#{attribute.to_s}=", stat['value'].to_s)
  end
end
