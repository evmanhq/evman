class CreateEventProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :event_properties do |t|
      t.string :name
      t.belongs_to :team

      t.timestamps
    end
  end
end
