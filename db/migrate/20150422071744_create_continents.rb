class CreateContinents < ActiveRecord::Migration[5.0]
  def change
    create_table :continents do |t|
      t.string      :code
      t.string      :name
      t.string      :geoid
      t.timestamps null: false
    end
  end
end
