class AddSeasonsToLeaguePlayerSeasonStat < ActiveRecord::Migration[5.1]
  def change
    add_column :league_player_season_stats, :season, :integer
  end
end
