class PerformanceMetric < ApplicationRecord
  belongs_to :team, inverse_of: :performance_metrics
  has_many :entries, class_name: "PerformanceMetricEntry", inverse_of: :performance_metric, dependent: :destroy
end
