class RenameEventsToEvent < ActiveRecord::Migration[5.1]

  def change
    rename_table :events, :events
  end
end
