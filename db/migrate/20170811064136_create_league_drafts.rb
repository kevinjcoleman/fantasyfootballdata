class CreateLeagueDrafts < ActiveRecord::Migration[5.1]
  def change
    create_table :league_drafts do |t|
      t.references :league, foreign_key: true
      t.integer :runs

      t.timestamps
    end
  end
end
