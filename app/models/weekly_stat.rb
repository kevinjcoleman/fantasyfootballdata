class WeeklyStat < ApplicationRecord
  enum status: [ :projected, :actual ]

  belongs_to :player
end
