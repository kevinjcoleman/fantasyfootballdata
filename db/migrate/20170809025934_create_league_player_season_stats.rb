class CreateLeaguePlayerSeasonStats < ActiveRecord::Migration[5.1]
  def change
    create_table :league_player_season_stats do |t|
      t.references :player, foreign_key: true
      t.references :league, foreign_key: true
      t.decimal :total_points

      t.timestamps
    end
  end
end
