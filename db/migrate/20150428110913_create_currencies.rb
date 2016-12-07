class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string      :code
      t.string      :name
      t.string      :symbol

      t.timestamps null: false
    end
  end
end
