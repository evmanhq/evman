class CreateEventSeries < ActiveRecord::Migration
  def change
    create_table :event_series do |t|
      t.string      :name
      t.references  :team
      t.timestamps
    end
  end
end
