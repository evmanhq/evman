class AddParentIdToEventPropertyOptions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :event_property_options, :parent, index: true
  end
end
