class LeagueParser
  attr_accessor :league
  def initialize(league)
    @league = league
  end

  def self.parse!(response)
    instance = new(ActiveSupport::HashWithIndifferentAccess.
                           new(response))
    instance.return_hash
  end

  def return_hash
    [:league_key, :name, :season, :url].each_with_object({}) do |attr, hash|
      hash[attr] = send(attr)
    end
  end

  LEAGUE_ATTRIBUTES = [:league_key, :league_id, :url, :name, :season]

  LEAGUE_ATTRIBUTES.each do |attr|
    define_method(attr) do
      league.dig attr
    end
  end
end
