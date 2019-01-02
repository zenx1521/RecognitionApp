class AddIsUploadedToSession < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :is_uploaded, :boolean
  end
end
