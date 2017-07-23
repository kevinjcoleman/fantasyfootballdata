class AddEspnShortSlugToNflTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :nfl_teams, :espn_short_slug, :string
  end
end
