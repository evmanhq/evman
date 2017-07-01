class CreateCountries < ActiveRecord::Migration[5.0]
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

  end
end
