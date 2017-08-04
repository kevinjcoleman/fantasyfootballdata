class AddEspnSlugToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :espn_slug, :string
  end
end
