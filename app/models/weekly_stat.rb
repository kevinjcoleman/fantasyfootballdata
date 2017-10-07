class WeeklyStat < ApplicationRecord
  STAT_TYPE_PROJECTED = 1
  STAT_TYPE_ACTUAL = 2

  belongs_to :player
  has_many :week_totals, class_name: 'WeeklyStatTotal', dependent: :destroy
  after_save :update_stat_totals


  def update_stat_totals
    League.where(season: 2017).find_each do |league|
      week_totals.where(league: league).first_or_create.tap do |weekly_total|
        weekly_total.total = StatsCalculator.total_points(league, self)
        weekly_total.save!
      end
    end
  end

  handle_asynchronously :update_stat_totals
end
