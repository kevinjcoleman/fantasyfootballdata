class Player < ApplicationRecord
  belongs_to :team, class_name: 'NflTeam'
  has_many :player_seasons

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
          stats.send("#{attr.to_s}=", hash[attr])
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

  def stats_url
    "http://www.espn.com/nfl/player/stats/_/id/#{espn_id}/#{espn_slug}"
  end
end
