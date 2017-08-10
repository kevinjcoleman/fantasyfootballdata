class AddHstoreIfDoesntExist < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    add_column :leagues, :roster_positions, :hstore
    add_index :leagues, :roster_positions, using: :gist
    add_column :leagues, :stat_categories, :hstore
    add_index :leagues, :stat_categories, using: :gist
  end
end
