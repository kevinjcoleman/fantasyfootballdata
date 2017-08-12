class LeagueTeamLoader
  attr_accessor :league, :user, :results
  def initialize(league, user)
    @league, @user = league, user
    load_teams
  end

  def load_teams
    @results = user.client.league_teams(league.league_key).dig("fantasy_content", "league")
  end

  def teams
    @teams ||= results.dig('teams', 'team').map do |hsh|
      LeagueTeam.new(hsh)
    end
  end

  class LeagueTeam
    attr_accessor :hsh
    def initialize(hsh)
      @hsh = hsh
    end

    ATTRIBUTES = %w(team_key
                    name
                    url)

    ATTRIBUTES.each do |attr|
      define_method(attr) do
        hsh.dig(attr)
      end
    end

    def logo_url
      hsh.dig('team_logos', 'team_logo', 'url')
    end

    def manager_key
      hsh.dig('managers', 'manager', 'guid')
    end

    def nickname
      hsh.dig('managers', 'manager', 'nickname')
    end
  end
end
