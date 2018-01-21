class RenameGroupEventsToEvents < ActiveRecord::Migration[5.1]

  def change
    rename_table :group_events, :events
  end
end
