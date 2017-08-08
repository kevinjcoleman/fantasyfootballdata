class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.references :league, foreign_key: true
      t.string :team_key
      t.string :name
      t.string :logo_url
      t.string :url

      t.timestamps
    end
  end
end
