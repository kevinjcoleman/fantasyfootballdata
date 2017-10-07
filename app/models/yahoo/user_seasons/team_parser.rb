class TeamParser
  # Parse information about a user's specific team.

  attr_accessor :team
  def initialize(team)
    @team = team
  end

  def self.parse!(response)
    instance = new(ActiveSupport::HashWithIndifferentAccess.
                           new(response))
    instance.return_hash
  end

  def return_hash
    [:team_key, :name, :logo_url, :url].each_with_object({}) do |attr, hash|
      hash[attr] = send(attr)
    end
  end

  TEAM_ATTRIBUTES = [:team_key, :team_id, :url, :name, :team_logos, :manager]

  TEAM_ATTRIBUTES.each do |attr|
    define_method(attr) do
      team.dig attr
    end
  end

  def logo_url
    team_logos.dig :team_logo, :url
  end
end
