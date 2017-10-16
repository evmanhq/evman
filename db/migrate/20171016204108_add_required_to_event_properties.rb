class AddRequiredToEventProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :event_properties, :required, :boolean, default: false
  end
end
