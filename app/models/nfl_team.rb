class NflTeam < ApplicationRecord
  validates :name, presence: true
  validates :espn_slug, presence: true

  has_many :players, foreign_key: 'team_id'

  def roster_url
    "http://www.espn.com/nfl/team/roster/_/name/#{espn_short_slug}/#{espn_slug}"
  end
end
