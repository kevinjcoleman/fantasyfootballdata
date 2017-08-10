class AddDefaultsToPlayerSeason < ActiveRecord::Migration[5.1]
  def change
    change_column :player_seasons, :passing_completions, :integer, default: 0
    change_column :player_seasons, :passing_attempts, :integer, default: 0
    change_column :player_seasons, :passing_yards, :integer, default: 0
    change_column :player_seasons, :passing_touchdowns, :integer, default: 0
    change_column :player_seasons, :passing_interceptions, :integer, default: 0
    change_column :player_seasons, :passing_qbr, :decimal, default: 0.0
    change_column :player_seasons, :passing_rating, :decimal, default: 0.0
    change_column :player_seasons, :rushing_attempts, :integer, default: 0
    change_column :player_seasons, :rushing_yards, :integer, default: 0
    change_column :player_seasons, :rushing_touchdowns, :integer, default: 0
    change_column :player_seasons, :receptions, :integer, default: 0
    change_column :player_seasons, :receiving_yards, :integer, default: 0
    change_column :player_seasons, :receiving_touchdowns, :integer, default: 0
    change_column :player_seasons, :fumbles, :integer, default: 0
    change_column :player_seasons, :fumbles_lost, :integer, default: 0
  end
end
