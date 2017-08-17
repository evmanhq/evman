class CreatePerformanceMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :performance_metrics do |t|
      t.string :name
      t.belongs_to :team, index: true

      t.timestamps
    end
  end
end
