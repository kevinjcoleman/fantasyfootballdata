class RosterParser
  # This pulls players for each roster on espn.
  attr_accessor :roster
  def initialize(roster)
    @roster = roster
  end

  def self.parse!(roster)
    instance = new(roster)
    instance.return_players
  end

  def return_players
    players = []
    roster.css('table').children.each_with_index do |row, i|
      next if i == 1
      if row['class'] == 'stathead'
        break if row.content == "Defense"
      elsif row['class'] != "colhead"
        players << parse_player_row(row, @headers)
      end
    end
    players
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
