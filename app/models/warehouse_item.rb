class WarehouseItem < ApplicationRecord
  belongs_to :warehouse, inverse_of: :items
  has_many :batches, class_name: 'WarehouseBatch', foreign_key: :item_id, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: [:warehouse_id], case_sensitive: false }

  def concerned_teams
    warehouse.concerned_teams
  end

end
