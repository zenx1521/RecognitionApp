class AddSessionAttachmentIdToPoint < ActiveRecord::Migration[5.0]
  def change
    add_column :points, :session_attachment_id, :string
    add_column :points, :integer, :string
  end
end
