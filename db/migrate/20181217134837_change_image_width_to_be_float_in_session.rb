class ChangeImageWidthToBeFloatInSession < ActiveRecord::Migration[5.0]
  def change
    change_column :session_attachments, :image_width, :float
    change_column :session_attachments, :image_height, :float
  end
end
