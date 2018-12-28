class CreateSessionStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :session_statuses do |t|
      t.boolean :finished
      t.integer :user_id
      t.integer :session_id

      t.timestamps
    end
  end
end
