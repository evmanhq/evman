class CreateWarehouseItems < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouse_items do |t|
      t.string :name
      t.belongs_to :warehouse, index: true

      t.timestamps
    end
  end
end
