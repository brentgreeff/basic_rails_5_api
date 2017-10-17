class CreateGroupEvents < ActiveRecord::Migration[5.1]

  def change
    create_table :group_events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.integer :duration
      t.date :starting
      t.date :ending
      t.boolean :published

      t.timestamps
    end
  end
end
