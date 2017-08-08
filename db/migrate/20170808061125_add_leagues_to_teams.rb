class AddLeaguesToTeams < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :owner, references: :users
  end
end
