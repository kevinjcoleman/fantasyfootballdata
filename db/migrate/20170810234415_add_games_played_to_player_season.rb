class AddGamesPlayedToPlayerSeason < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :games_played, :integer, default: 0
  end
end
