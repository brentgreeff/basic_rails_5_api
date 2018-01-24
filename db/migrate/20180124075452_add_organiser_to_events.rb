class AddOrganiserToEvents < ActiveRecord::Migration[5.1]

  def change
    add_column :events, :organiser_id, :integer, foreign_key: true
    change_column_null :events, :organiser_id, false
  end
end
