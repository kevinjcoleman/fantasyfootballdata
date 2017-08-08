class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :league_key
      t.string :name
      t.string :url
      t.integer :season

      t.timestamps
    end
  end
end
