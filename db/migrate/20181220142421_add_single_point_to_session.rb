class AddSinglePointToSession < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :single_point, :boolean
  end
end
