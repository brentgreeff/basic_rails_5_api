class AddGroupToEvents < ActiveRecord::Migration[5.1]

  def change
    add_reference :events, :group, foreign_key: true
  end
end
