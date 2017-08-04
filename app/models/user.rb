class User < ApplicationRecord
  def self.from_auth(auth)
    where(uid: auth.uid).first_or_create.tap do |user|
      user.name = auth.info.name
      user.token = auth[:credentials][:token]
      user.refresh_token = auth[:credentials][:refresh_token]
      user.save!
    end
  end

  def fetch_teams
    UserSeasons.parse!(client.teams.to_hash)
  end

  def client
    @client ||= YahooApi.new(self)
  end

  def refresh_token!
    TokenRefresher.refresh(self)
  end
end
