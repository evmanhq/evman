class CreateAttendeeTypes < ActiveRecord::Migration[5.0]

  def change
    create_table :attendee_types do |t|
      t.string      :name
      t.references  :team
      t.boolean     :default, :default => false, :null => false
      t.timestamps
    end
  end

end
