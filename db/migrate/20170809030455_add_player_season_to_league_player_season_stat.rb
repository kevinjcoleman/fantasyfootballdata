class AddPlayerSeasonToLeaguePlayerSeasonStat < ActiveRecord::Migration[5.1]
  def change
    add_reference :league_player_season_stats, :player_season, references: :player_seasons
    remove_column :league_player_season_stats, :season
    remove_column :league_player_season_stats, :player_id
  end
end
