class AddPlayerToPlayerStats < ActiveRecord::Migration[5.1]
  def change
    add_reference :player_seasons, :player, foreign_key: true
  end
end
