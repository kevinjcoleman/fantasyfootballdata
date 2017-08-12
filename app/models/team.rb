class Team < ApplicationRecord
  belongs_to :league
  belongs_to :owner, class_name: 'User'
  has_many :team_members
  has_many :players, through: :team_members
end
