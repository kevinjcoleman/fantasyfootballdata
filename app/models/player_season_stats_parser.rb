class PlayerSeasonStatsParser
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def self.parse!(roster)
    instance = new(roster)
    instance.return_stats
  end

  def return_stats
    stats_array = tables.each_with_object([]) do |table, array|
      array << table.output_stats
    end
    stats_array.each_with_object(Hash.new {|hash, key| hash[key] = {fumbles: 0, fumbles_lost: 0} }) do |stat_type, hash|
      stat_type.each do |season, stats|
        hash[season][:fumbles] += (stats.delete('fumbles').try(:to_i) || 0)
        hash[season][:fumbles_lost] += (stats.delete('fumbles_lost').try(:to_i) || 0)
        hash[season].merge!(stats.symbolize_keys)
      end
    end
  end

  def tables
    parsers = data.css('table.tablehead').map {|t| StatTableParser.new(t) }
    parsers.select {|p| p.accepted_stat? }
  end

  ROW_HEADERS = {0 => :number,
                 1 => :name,
                 2 => :position,
                 3 => :age,
                 4 => :height,
                 5 => :weight,
                 6 => :experience,
                 7 => :college,
  }

  def parse_player_row(row, headers)
    player = {}
    row.children.each_with_index do |td, j|
      if td.css('a').any?
        player[ROW_HEADERS[j]] = td.css('a').first.content
        player[:espn_id] = td.css('a').first['href'].match(/id\/(\d+)\//)[1].to_i
        player[:espn_slug] = td.css('a').first['href'].match(/\d\/(.+)$/)[1]
      else
        player[ROW_HEADERS[j]] = td.content
      end
    end
    player
  end
end
