class NflTeam < ApplicationRecord
  validates :name, presence: true
  validates :espn_slug, presence: true 
end
