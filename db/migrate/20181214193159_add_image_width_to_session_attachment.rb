class AddImageWidthToSessionAttachment < ActiveRecord::Migration[5.0]
  def change
    add_column :session_attachments, :image_width, :integer
  end
end
