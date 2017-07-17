class AddPositionToEventProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :event_properties, :position, :integer, default: 1
  end
end
