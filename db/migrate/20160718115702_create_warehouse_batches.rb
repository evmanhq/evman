class CreateWarehouseBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouse_batches do |t|
      t.belongs_to :item, index: true
      t.decimal :price, precision: 11, scale: 2
      t.integer :total

      t.timestamps
    end
  end
end
