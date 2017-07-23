class CreateNflTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :nfl_teams do |t|
      t.string :name
      t.string :espn_slug

      t.timestamps
    end
  end
end
