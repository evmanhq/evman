class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string      :code
      t.string      :name
      t.string      :tld
      t.string      :geoid

      t.references  :currency
      t.references  :continent

      t.timestamps null: false
    end

    add_index :countries, :currency_id
    add_index :countries, :continent_id
  end
end
