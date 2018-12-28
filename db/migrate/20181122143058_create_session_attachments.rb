class CreateSessionAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :session_attachments do |t|
      t.integer :session_id
      t.string :image

      t.timestamps
    end
  end
end
