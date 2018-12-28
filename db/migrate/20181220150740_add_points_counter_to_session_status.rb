class AddPointsCounterToSessionStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :session_statuses, :points_counter, :integer
  end
end
