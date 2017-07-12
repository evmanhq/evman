class AddPropertiesAssignmenttsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :properties_assignments, :jsonb
  end
end
