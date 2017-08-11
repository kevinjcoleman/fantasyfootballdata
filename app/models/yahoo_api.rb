class YahooApi
  # General API info here https://developer.yahoo.com/fantasysports/guide/#game-resource-sub_resources
  # API endpoint information located here https://developer.yahoo.com/fantasysports/guide/player-resource.html

  BASE = "https://fantasysports.yahooapis.com/fantasy/v2"
  def initialize(user)
    @user = user
  end

  def teams
    get("#{BASE}/users;use_login=1/games/leagues/teams")
  end

  def team(team_id)
    get("#{BASE}/team/#{team_id}")
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

  def league_players(league_id, start)
    # iterate by appending ';start=25'
    get("https://fantasysports.yahooapis.com/fantasy/v2/league/#{league_id}/players;start=#{start}")
  end

  def league_settings(league_id)
    get("https://fantasysports.yahooapis.com/fantasy/v2/league/#{league_id}/settings")
  end

  def leagues
    get("https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games")
  end

  def get(url, errors = 0)
    response = HTTParty.get(url,
                  :headers => headers)
    puts response
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
