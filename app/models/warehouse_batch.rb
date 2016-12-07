class WarehouseBatch < ApplicationRecord
  belongs_to :item, class_name: 'WarehouseItem', inverse_of: :batches
  has_many :transactions, class_name: 'WarehouseTransaction', inverse_of: :batch, foreign_key: :batch_id, dependent: :destroy
  has_one :initial_transaction, -> { where("count > ?", 0) }, class_name: 'WarehouseTransaction', foreign_key: :batch_id

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :item, presence: true

  def label
    h = ApplicationController.helpers
    "#{item.name} - #{h.number_to_currency price} - #{h.l created_at.to_date, format: :long} - #{total} on stock"
  end

  def update_total
    new_total = transactions.sum(:total)
    update_attribute(:total, new_total)
  end
end
