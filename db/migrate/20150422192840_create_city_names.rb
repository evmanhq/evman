class CreateCityNames < ActiveRecord::Migration[5.0]
  def change
    create_table :city_names do |t|
      t.string      :geoid

      t.string      :name
      t.string      :keyword

      t.references  :city
      t.references  :language

      t.timestamps null: false
    end

    add_index :city_names, :geoid
    add_index :city_names, :keyword

  end
end
