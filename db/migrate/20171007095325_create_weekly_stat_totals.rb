class CreateWeeklyStatTotals < ActiveRecord::Migration[5.1]
  def change
    create_table :weekly_stat_totals do |t|
      t.references :league, foreign_key: true
      t.references :weekly_stat, foreign_key: true
      t.float :total

      t.timestamps
    end
  end
end
