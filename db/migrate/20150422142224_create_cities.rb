class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string      :geoid

      t.references  :country
      t.references  :time_zone

      t.float       :lat
      t.float       :lon

      t.timestamps null: false
    end

    add_index :cities, :geoid
    add_index :cities, :country_id
    add_index :cities, :time_zone_id

  end
end
