class AddPopulationToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :population, :bigint, default: 0
  end
end
