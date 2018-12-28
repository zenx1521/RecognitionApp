class AddAttachmentIdToPoint < ActiveRecord::Migration[5.0]
  def change
    add_column :points, :attachment_id, :integer
  end
end
