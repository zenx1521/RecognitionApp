class CreateMarks < ActiveRecord::Migration[5.0]
  def change
    create_table :marks do |t|
      t.string :description
      t.integer :point_id
      t.integer :user_id

      t.timestamps
    end
  end
end
