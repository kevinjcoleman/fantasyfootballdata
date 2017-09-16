class AddFantasyProProjections
  def self.run!
    instance = new
    instance.get_stat_projections
    instance.get_projections
    instance.create_projections
  end

  POSITIONS = {rb: "https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php",
               qb: 'https://www.fantasypros.com/nfl/rankings/qb.php',
               wr: 'https://www.fantasypros.com/nfl/rankings/half-point-ppr-wr.php',
               te: 'https://www.fantasypros.com/nfl/rankings/half-point-ppr-te.php'
  }
  def get_projections
    @ranking_projections = []
    POSITIONS.each do |position, link|
      @ranking_projections += PositionProjection.new(position, link).get_projections
    end
  end

  QB_STAT_PROJECTION_LINK = 'https://www.fantasypros.com/nfl/projections/qb.php'
  RB_STAT_PROJECTION_LINK = 'https://www.fantasypros.com/nfl/projections/rb.php'
  WR_STAT_PROJECTION_LINK = 'https://www.fantasypros.com/nfl/projections/wr.php'
  TE_STAT_PROJECTION_LINK = 'https://www.fantasypros.com/nfl/projections/te.php'
  def get_stat_projections
    @stat_projections = []

    @stat_projections += WeeklyProjection.new(:qb, QB_STAT_PROJECTION_LINK).get_projections(QbProjectionRow)
    @stat_projections += WeeklyProjection.new(:rb, RB_STAT_PROJECTION_LINK).get_projections(RbWrProjectionRow)
    @stat_projections += WeeklyProjection.new(:wr, WR_STAT_PROJECTION_LINK).get_projections(RbWrProjectionRow)
    @stat_projections += WeeklyProjection.new(:te, TE_STAT_PROJECTION_LINK).get_projections(TeProjectionRow)
    @stat_projections
  end

  def create_projections
    @ranking_projections.each do |projection|
      stat_projection = @stat_projections.find {|proj| proj[:player_slug] == projection[:player_slug]}
      projection.merge!(stat_projection) if stat_projection
      player = Player.where(fantasy_pro_slug: projection[:player_slug]).first || Player.where(name: projection[:name], position: projection[:position].to_s.upcase).first || Player.where(fantasy_pro_slug: projection[:player_slug], name: projection[:name], position: projection[:position].to_s.upcase).first_or_create # rescue binding.pry
      player.fantasy_pro_slug = projection[:player_slug]
      next unless player.save
      stats = WeeklyStat.where(week: projection[:week].to_i, player_id: player.id).first_or_create
      projection.except(:player_slug, :name, :position).each do |k, v|
        stats.send("#{k}=", v) if v
      end #rescue binding.pry
      stats.save! rescue binding.pry
    end
  end

  class PositionProjection
    attr_accessor :doc, :position
    def initialize(position, link)
      @doc = WebDocument.new(link).doc
      @position = position
    end

    def get_projections
      @doc.css(".player-table tbody").children.map {|tr| TableRowParser.new(tr, week, position).to_hsh }.compact
    end

    def week
      doc.css('h1').text.match(/Week (.+) /)[1].to_i
    end
  end

  class TableRowParser
    attr_accessor :tr
    def initialize(tr, week, position)
      @week, @position = week, position
      @tr = tr
    end

    def to_hsh
      return nil if tr.content.blank? || !tr.css(".player-label a").first
      {name: name,
       player_slug: player_slug,
       matchup: matchup,
       notes: notes,
       week: @week,
       position: @position}.merge(rankings)
    end

    def name
      tr.css(".player-label a").text
    end

    def player_slug
      # binding.pry unless tr.css(".player-label a").first
      tr.css(".player-label a").first.attributes['href'].value.match(/\/nfl\/players\/(.+).php/)[1]
    end

    def matchup
      tr.css("td")[2].text.match(/\w{2,3}$/).to_s rescue 'N/A'
    end

    RANKS = {0 => 'best',
             1 => 'worst',
             2 => 'average',
             3 => 'std_dev'}
    def rankings
      rankings = {}
      tr.css("td.ranks").each_with_index do |td, i|
        rankings[RANKS[i]] = td.text
      end
      rankings
    end

    def notes
      tr.css("td")[7].text
    end
  end

  class WeeklyProjection < PositionProjection
    def get_projections(subject)
      @doc.css("#data tbody").children.map {|tr| subject.new(tr, week, position).to_hsh }.compact
    end
  end

  class ProjectionRow < TableRowParser
    def to_hsh
      return nil if tr.content.blank? || !tr.css(".player-label a").first
      {name: name,
       player_slug: player_slug,
       week: @week,
       position: @position}.merge(scores)
    end

    def player_slug
      # binding.pry unless tr.css(".player-label a").first
       tr.css(".player-label a").first.attributes['href'].value.match(/\/nfl\/projections\/(.+).php/)[1] rescue nil
    end
  end

  class QbProjectionRow < ProjectionRow
    RANKS = {0 => 'passing_attempts',
             1 => 'passing_completions',
             2 => 'passing_yards',
             3 => 'passing_touchdowns',
             4 => 'passing_interceptions',
             5 => 'rushing_attempts',
             6 => 'rushing_yards',
             7 => 'rushing_touchdowns',
             8 => 'fumbles_lost'}
    def scores
      score = {}
      tr.css("td.center").each_with_index do |td, i|
        score[RANKS[i]] = td.text
      end
      score.keep_if {|k, v| k }
    end
  end

  class RbWrProjectionRow < ProjectionRow
    RANKS = {0 => 'rushing_attempts',
             1 => 'rushing_yards',
             2 => 'rushing_touchdowns',
             3 => 'receptions',
             4 => 'receiving_yards',
             5 => 'receiving_touchdowns',
             6 => 'fumbles_lost'}
    def scores
      score = {}
      tr.css("td.center").each_with_index do |td, i|
        score[RANKS[i]] = td.text
      end
      score.keep_if {|k, v| k }
    end
  end

  class TeProjectionRow < ProjectionRow
    RANKS = {0 => 'receptions',
             1 => 'receiving_yards',
             2 => 'receiving_touchdowns',
             3 => 'fumbles_lost'}
    def scores
      score = {}
      tr.css("td.center").each_with_index do |td, i|
        score[RANKS[i]] = td.text
      end
      score.keep_if {|k, v| k }
    end
  end
end
AddFantasyProProjections.run!
