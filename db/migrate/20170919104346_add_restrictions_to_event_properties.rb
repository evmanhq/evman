class AddRestrictionsToEventProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :event_properties, :restrictions, :jsonb
    add_column :event_property_options, :restrictions, :jsonb
  end
end
