class CreateEventTalks < ActiveRecord::Migration[5.0]
  def change
    create_table :event_talks do |t|

      t.references  :talk
      t.references  :event
      t.references  :user

      t.boolean     :state, :default => nil

      t.timestamps
    end
  end
end
