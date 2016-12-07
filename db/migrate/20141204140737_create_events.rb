class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string      :name

      t.boolean     :committed
      t.boolean     :approved
      t.boolean     :archived

      t.references  :city
      t.string      :location
      t.string      :url

      t.string      :sponsorship
      t.date        :sponsorship_date

      t.string      :cfp_url
      t.date        :cfp_date

      t.date        :begins_at
      t.date        :ends_at

      t.references  :team
      t.references  :owner

      t.references  :event_series
      t.references  :event_type

      t.timestamps
    end

    add_index :events, :city_id
    add_index :events, :team_id
    add_index :events, :owner_id
    add_index :events, :event_series_id
    add_index :events, :event_type_id

  end
end
