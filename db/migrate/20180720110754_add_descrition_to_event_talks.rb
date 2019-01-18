class AddDescritionToEventTalks < ActiveRecord::Migration[5.1]
  def change
    add_column :event_talks, :description, :text
  end
end
