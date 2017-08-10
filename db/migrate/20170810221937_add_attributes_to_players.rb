class AddAttributesToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :yahoo_key, :string
    add_column :players, :image_url, :string
  end
end
