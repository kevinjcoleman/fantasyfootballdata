class AddPositionRankingAndPointPositiveToPlayerSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :league_player_season_stats, :position_ranking, :integer, default: 0
    add_column :league_player_season_stats, :point_differential, :decimal, default: 0.0
  end
end
