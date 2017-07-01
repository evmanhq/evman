class CreateEventNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :event_notes do |t|
      t.references  :user
      t.references  :event
      t.text        :content
      t.timestamps null: false
    end
  end
end
