class StatTableParser

  PASSING_ATTRS = { 0 => 'season',
                    3 => "passing_completions",
                    4 => "passing_attempts",
                    6 => "passing_yards",
                    8 => "passing_touchdowns",
                    10 => "passing_interceptions",
                    11 => 'fumbles',
                    12 => "passing_qbr",
                    13 => "passing_rating"

  }

  RECEIVING_ATTRS = { 0 => 'season',
                      3 => 'receptions',
                      4 => 'targets',
                      5 => "receiving_yards",
                      8 => "receiving_touchdowns",
                      10 => "fumbles",
                      11 => 'fumbles_lost'
  }

  RUSHING_ATTRS = { 0 => 'season',
                    3 => "rushing_attempts",
                    4 => "rushing_yards",
                    7 => "rushing_touchdowns",
                    9 => "fumbles",
                    10 => 'fumbles_lost'
  }

  ALL_ATTRS = [PASSING_ATTRS, RECEIVING_ATTRS, RUSHING_ATTRS].map(&:values).flatten.uniq.map {|v| v.to_sym }.freeze


  attr_accessor :data

  def initialize(data)
    @data = data
  end

  ACCEPTED_TYPES = ["passing",
                    "rushing",
                    "receiving"]

  def accepted_stat?
    type.in?(ACCEPTED_TYPES)
  end

  def output_stats
    send("#{type}_parser".to_sym)
  end



  def passing_parser
    output_season_stats(PASSING_ATTRS)
  end

  def rushing_parser
    output_season_stats(RUSHING_ATTRS)
  end


  def receiving_parser
    output_season_stats(RECEIVING_ATTRS)
  end

  def stat_rows
    data.css('tr.oddrow') + data.css('tr.evenrow')
  end

  def season(row)
    row.children.first.text
  end

  def output_season_stats(attribute_array)
    stat_rows.each_with_object({}) do |row, hash|
      season_stats = {}
      row.children.each_with_index do |td, i|
        if key = attribute_array[i]
          if key.match?(/rating$|qbr$/)
            season_stats[key] = td.text.to_f
          else
            season_stats[key] = td.text.gsub(/[^\d]/, '').to_i
          end
        end
      end
      hash[season(row)] = season_stats
    end
  end

  def passing?
    type == "passing"
  end

  def rushing?
    type == "rushing"
  end

  def receiving?
    type == "receiving"
  end

  def type
    data.search('tr.stathead td').text.gsub(/[^\w]+$/, "").split(' ').first.downcase
  end
end
