class Player < ApplicationRecord
  belongs_to :team, class_name: 'NflTeam'
  has_many :player_seasons
  has_many :weekly_stats
  has_many :team_members
  has_many :teams, through: :team_members

  validates :yahoo_key, uniqueness: :true, unless: :yahoo_key_nil?
  validates :espn_id, uniqueness: :true, unless: :espn_id_nil?

  def self.add_from_website(hsh, team)
    where(espn_id: hsh[:espn_id]).first_or_create.tap do |plyr|
      RosterParser::ROW_HEADERS.values.push(:espn_slug).each do |attr|
        plyr.send("#{attr.to_s}=", hsh[attr])
      end
      plyr.team = team
      plyr.save!
    end
  end

  def backfill_stats
    PlayerSeasonStatsParser.parse!(WebDocument.new(stats_url).doc).each do |season, hash|
      PlayerSeason.where(season: season.to_i, player_id: self.id).first_or_create.tap do |stats|
        StatTableParser::ALL_ATTRS.each do |attr|
          default = attr.to_s.in?(['passing_qbr', 'passing_rating']) ? 0.0 : 0
          stats.send("#{attr.to_s}=", (hash[attr] || default))
        end
        stats.save!
      end
    end
  end

  def stat_columns
    if position.in?(['WR', "TE", 'RB', "FB"])
      columns_to_symbols((StatTableParser::RECEIVING_ATTRS.values + StatTableParser::RUSHING_ATTRS.values).uniq)
    else
      columns_to_symbols(StatTableParser::PASSING_ATTRS.values.push('fumbles_lost'))
    end
  end

  def columns_to_symbols(array)
    array.map {|v| v.to_sym }
  end

  def espn_id_nil?
    espn_id.nil?
  end

  def yahoo_key_nil?
    yahoo_key.nil?
  end

  def yahoo_player_info(user=User.first)
    user.client.player(yahoo_key)
  end

  def stats_url
    "http://www.espn.com/nfl/player/stats/_/id/#{espn_id}/#{espn_slug}"
  end

  def weekly_stat_for_season(season, week)
    weekly_stats.where(week: week.to_i, stat_type: WeeklyStat::STAT_TYPE_ACTUAL).first_or_create.tap do |weekly_stat|
      begin
        stats = User.first.client.weekly_stat(self.yahoo_key, season, week).dig('fantasy_content',
                     'player',
                     'player_stats',
                     'stats',
                     'stat').
                     select {|hsh| hsh['stat_id'].in?(YahooStatId.accepted_ids - ["0"])}
        stats.each do |stat|
          attribute = YahooStatId.name_from_stat_id(stat['stat_id'])
          weekly_stat.send("#{attribute.to_s}=", stat['value'].to_s)
        end
        weekly_stat.save!
      rescue => e
        puts e.message
      end 
    end
  end
end
