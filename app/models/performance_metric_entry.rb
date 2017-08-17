class PerformanceMetricEntry < ApplicationRecord
  belongs_to :performance_metric, inverse_of: :entries
  belongs_to :event

  validates :event_id, presence: true
  validates :performance_metric_id, presence: true, uniqueness: { scope: [:event_id] }

  def label
    performance_metric.name
  end

  def percentage
    return nil if target.to_s.to_d.zero?
    actual.to_s.to_d / target.to_s.to_d * 100
  end
end
