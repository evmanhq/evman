class CreateWarehouseTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :warehouse_transactions do |t|
      t.integer :count, default: 0
      t.integer :returned, default: 0
      t.integer :total, default: 0
      t.string :description
      t.belongs_to :batch, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
