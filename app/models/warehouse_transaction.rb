class WarehouseTransaction < ApplicationRecord
  belongs_to :batch, class_name: 'WarehouseBatch', inverse_of: :transactions
  belongs_to :event, inverse_of: :warehouse_transactions
  has_one :item, through: :batch, class_name: "WarehouseItem"

  before_validation :calculate_total
  after_save :update_batch_total

  before_destroy :lock_batch
  after_destroy :update_batch_total

  scope :with_price, -> { joins(:batch).select("warehouse_transactions.*, - warehouse_transactions.total *  price AS price") }
  scope :assignments, -> { where('count < 0') }

  validates :batch_id, presence: true

  def price
    read_attribute(:price) || -total * batch.price
  end

  def initial?
    count > 0
  end

  private
  def calculate_total
    self.total = count + returned
  end

  def update_batch_total
    batch.update_total
  end

  def lock_batch
    batch.lock!
  end
end
