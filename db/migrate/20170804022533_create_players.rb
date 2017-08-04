class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.integer :number
      t.string :name
      t.string :position
      t.integer :age
      t.string :espn_id
      t.string :height
      t.integer :weight
      t.integer :experience
      t.string :college

      t.timestamps
    end
  end
end
