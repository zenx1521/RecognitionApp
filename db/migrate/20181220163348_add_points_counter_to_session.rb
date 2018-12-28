class AddPointsCounterToSession < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :points_counter, :integer
  end
end
