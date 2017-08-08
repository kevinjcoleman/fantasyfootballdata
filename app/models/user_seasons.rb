class UserSeasons
  attr_accessor :seasons

  def initialize(seasons)
    @seasons = seasons
  end
  
  def self.parse!(response)
    instance = new(ActiveSupport::HashWithIndifferentAccess.
                           new(response).
                           dig :fantasy_content,
                           :users,
                           :user,
                           :games,
                           :game)
    instance.parse_seasons
  end

  def parse_seasons
    seasons.each_with_object({}) do |season, hash|
      hash[season[:season]] = SeasonParser.parse!(season)
    end
  end
end
