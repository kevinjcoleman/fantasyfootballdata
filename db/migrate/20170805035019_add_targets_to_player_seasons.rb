class AddTargetsToPlayerSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :targets, :integer
  end
end
