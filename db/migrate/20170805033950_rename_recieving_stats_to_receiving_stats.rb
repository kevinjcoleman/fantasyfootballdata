class RenameRecievingStatsToReceivingStats < ActiveRecord::Migration[5.1]
  def change
    rename_column :player_seasons, :recieving_yards, :receiving_yards
    rename_column :player_seasons, :recieving_touchdowns, :receiving_touchdowns
  end
end
