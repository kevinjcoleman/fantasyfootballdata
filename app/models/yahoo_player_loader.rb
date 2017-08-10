class YahooPlayerLoader
  attr_accessor :league, :user, :players

  def initialize(user, league)
    @user, @league = user, league
  end

  def players
    @players ||= fetch_next_players
  end

  def fetch_next_players(count=0)
    players = []
    results = YahooPlayersResponse.new(user.client.league_players(league.league_key, count))
    players += results.players
    players += fetch_next_players(results.players.count + count) if results.players.count == 25
    players
  rescue => e
    puts "Count: #{count}"
  end

  # This class takes the response and creates a yahoo player instance for every record.
  class YahooPlayersResponse
    include Enumerable

    attr_accessor :response
    def initialize(response)
      @response = response
    end

    def each(&block)
      players.each(&block)
    end

    def first
      players.first
    end

    def players
      @players ||= players_hash_array.map do |plyr_hash|
        YahooPlayer.new(plyr_hash)
      end
    end

    def players_hash_array
      response.dig("fantasy_content", "league", "players", "player")
    end

    def count
      players.count
    end
  end

  # This class takes an individual player response hash and returns it's important information.
  class YahooPlayer
    attr_accessor :player
    def initialize(player)
      @player = player
    end

    def key
      player.dig('player_key')
    end

    def full_name
      player.dig('name', 'full')
    end

    def position
      player.dig('display_position')
    end

    def image
      player.dig('image_url')
    end

    def number
      player.dig('uniform_number').to_i
    end

    TEAMS = {'was' => 'wsh'}
    def team
      team = player.dig('editorial_team_abbr').downcase
      team = TEAMS[team] if team.in?(TEAMS.keys)
      team
    end
  end
end
