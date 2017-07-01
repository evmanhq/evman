class CreateTimeZones < ActiveRecord::Migration[5.0]
  def change
    create_table :time_zones do |t|
      t.string      :name

      t.float       :gmt
      t.float       :dst
      t.float       :dst_starts_at

      t.timestamps null: false
    end
  end
end
