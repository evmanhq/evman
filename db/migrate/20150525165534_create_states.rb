class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string      :geoid
      t.string      :code

      t.string      :name

      t.references  :country

      t.timestamps null: false
    end

    add_index   :states, :geoid

    add_column  :cities, :state_id, :integer
    add_column  :cities, :display, :string
  end
end
