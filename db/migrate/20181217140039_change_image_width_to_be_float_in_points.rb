class ChangeImageWidthToBeFloatInPoints < ActiveRecord::Migration[5.0]
  def change
    change_column :points, :x, :float
    change_column :points, :y, :float
  end
end
