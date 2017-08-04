class ChangeTeamsToTeam < ActiveRecord::Migration[5.1]
  def change
    rename_column :players, :teams_id, :team_id
  end
end
