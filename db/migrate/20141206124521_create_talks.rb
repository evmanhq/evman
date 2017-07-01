class CreateTalks < ActiveRecord::Migration[5.0]
  def change
    create_table :talks do |t|

      t.references  :team
      t.references  :user
      t.references  :event_type
      t.references  :event_series

      t.string      :name
      t.text        :abstract

      t.boolean     :archived, :default => false

      t.timestamps
    end
  end
end
