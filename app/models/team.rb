class Team < ApplicationRecord
  belongs_to :league
  belongs_to :owner, class_name: 'User'
end
