class CreateCities < ActiveRecord::Migration[5.0]
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

  end
end
