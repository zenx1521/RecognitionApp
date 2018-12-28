class CreateCheckboxes < ActiveRecord::Migration[5.0]
  def change
    create_table :checkboxes do |t|
      t.string :description
      t.integer :session_id

      t.timestamps
    end
  end
end
