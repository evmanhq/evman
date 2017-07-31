class AddColorToEventTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :event_types, :color, :string, limit: 7
  end
end
