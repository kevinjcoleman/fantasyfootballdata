class User < ApplicationRecord
  has_many :teams, foreign_key: 'owner_id'

  CURRENT_YEAR = 2017.freeze

  def self.from_auth(auth)
    where(uid: auth.uid).first_or_create.tap do |user|
      user.name = auth.info.name
      user.token = auth[:credentials][:token]
      user.refresh_token = auth[:credentials][:refresh_token]
      user.save!
    end
  end

  def fetch_teams
    UserSeasons.parse!(client.teams.to_hash).
                select {|year, seasons| year.to_i == CURRENT_YEAR }.
                flatten.last.each do |season|
      league = League.where(league_key: season[:league_key]).first_or_create.tap do |l|
        l.name = season[:name]
        l.season = season[:season].to_i
        l.url = season[:url]
        l.save!
      end
      Team.where(owner_id: id, league_id: league.id, team_key: season.dig(:team, :team_key)).first_or_create.tap do |t|
        t.name = season.dig(:team, :name)
        t.logo_url = season.dig(:team, :logo_url)
        t.url = season.dig(:team, :url)
        t.save!
      end
    end
  end

  def client
    @client ||= YahooApi.new(self)
  end

  def refresh_token!
    TokenRefresher.refresh(self)
  end
end
