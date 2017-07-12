class CreateEventPropertyOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :event_property_options do |t|
      t.string :name
      t.belongs_to :property

      t.timestamps
    end
  end
end
