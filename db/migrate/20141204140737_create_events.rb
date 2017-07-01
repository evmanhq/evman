class CreateEvents < ActiveRecord::Migration[5.0]
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

  end
end
