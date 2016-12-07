class CreateWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouses do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :teams, :warehouses do |t|
      t.index :team_id
      t.index :warehouse_id
    end
  end
end
