class CreatePerformanceMetricEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :performance_metric_entries do |t|
      t.belongs_to :performance_metric, index: true
      t.belongs_to :event, index: true
      t.decimal :target, precision: 11, scale: 3, default: 0
      t.decimal :actual, precision: 11, scale: 3, default: 0

      t.timestamps
    end
  end
end
