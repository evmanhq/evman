class Warehouse < ApplicationRecord
  has_and_belongs_to_many :teams
  has_many :items, class_name: 'WarehouseItem', dependent: :destroy

  validates :name, presence: true
  validate do |warehouse|
    warehouse.teams.each do |team|
      warehouse.errors.add :name, :taken if team.warehouses.where('name ILIKE ? AND id != ?', warehouse.name, warehouse.id.to_i).any?
    end
  end
end
