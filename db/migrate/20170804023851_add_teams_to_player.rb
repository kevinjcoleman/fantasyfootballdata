class AddTeamsToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_reference :players, :teams, references: :nfl_teams
  end
end
