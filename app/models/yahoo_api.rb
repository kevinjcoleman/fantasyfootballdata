class YahooApi
#  GAME_KEY      = Settings.game_key
#  LEAGUE_NUMBER = Settings.league_number
#  LEAGUE_KEY    = "#{GAME_KEY}.l.#{LEAGUE_NUMBER}"
#  BASE_URL      = "http://fantasysports.yahooapis.com/fantasy/v2"
#  LEAGUE_URL    = "#{BASE_URL}/league/#{LEAGUE_KEY}"

  def initialize(user)
    @user = user
  end

  def teams
    get("https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games/leagues/teams")
  end

  def team(team_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/team/#{team_id}")
  end

  def team_matchups(team_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/team/#{team_id}/matchups")
  end

  def players(team_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/team/#{team_id}/players")
  end

  def league(league_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/league/#{league_id}")
  end

  def league_teams(league_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/league/#{league_id}/teams")
  end

  def league_players(league_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/league/#{league_id}/players")
  end

  def leagues
    get("https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games")
  end

  def get(url, errors = 0)
    response = HTTParty.get(url,
                  :headers => headers)
    if error_response = response["error"]
      puts error_response
      raise "Too many retries" if errors > 5
      @user.refresh_token!; @user = @user.reload
      response = get(url, errors + 1)
    end
    response
  end

  def headers
    { "Authorization" => "Bearer #{@user.token}"}
  end
end
