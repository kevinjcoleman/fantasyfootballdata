class CreateWeeklyStats < ActiveRecord::Migration[5.1]
  def change
    create_table :weekly_stats do |t|
      t.string :matchup
      t.text :notes
      t.integer :week, default: 0
      t.integer :best, default: 0
      t.integer :worst, default: 0
      t.decimal :average, default: 0.0
      t.decimal :std_dev, default: 0.0
      t.integer :passing_completions, default: 0
      t.integer :passing_attempts, default: 0
      t.integer :passing_yards, default: 0
      t.integer :passing_touchdowns, default: 0
      t.integer :passing_interceptions, default: 0
      t.integer :rushing_attempts, default: 0
      t.integer :rushing_yards, default: 0
      t.integer :rushing_touchdowns, default: 0
      t.integer :receptions, default: 0
      t.integer :receiving_yards, default: 0
      t.integer :receiving_touchdowns, default: 0
      t.integer :fumbles, default: 0
      t.integer :fumbles_lost, default: 0
      t.integer :stat_type, default: 1


      t.timestamps
    end
    add_column :players, :fantasy_pro_slug, :string
    add_reference :weekly_stats, :player, index: true
    add_foreign_key :weekly_stats, :players
  end
end
