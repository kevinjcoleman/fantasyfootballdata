class CreatePlayerSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :player_seasons do |t|
      t.integer :season
      t.integer :passing_completions
      t.integer :passing_attempts
      t.integer :passing_yards
      t.integer :passing_touchdowns
      t.integer :passing_interceptions
      t.decimal :passing_qbr
      t.decimal :passing_rating
      t.integer :rushing_attempts
      t.integer :rushing_yards
      t.integer :rushing_touchdowns
      t.integer :receptions
      t.integer :recieving_yards
      t.integer :recieving_touchdowns
      t.integer :fumbles
      t.integer :fumbles_lost

      t.timestamps
    end
  end
end
