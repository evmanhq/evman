class CreateAttendees < ActiveRecord::Migration[5.0]

  def change
    create_table :attendees do |t|
      t.references  :user
      t.references  :event
      t.references  :attendee_type
      t.timestamps
    end

  end

end
