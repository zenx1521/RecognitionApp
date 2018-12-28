class AddMarkedCounterToSessionStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :session_statuses, :marked_counter, :integer
  end
end
