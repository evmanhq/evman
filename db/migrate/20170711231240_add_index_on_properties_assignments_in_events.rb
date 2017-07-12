class AddIndexOnPropertiesAssignmentsInEvents < ActiveRecord::Migration[5.1]
  def change
    add_index :events, :properties_assignments, using: :gin
  end
end
