class AddPositionRankingAndPointPositiveToPlayerSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :position_ranking, :integer
    add_column :player_seasons, :point_positive, :decimal
  end
end
