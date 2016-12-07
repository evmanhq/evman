FactoryGirl.define do
  factory :warehouse do
    sequence(:name) { |x| "Warehouse #{x}" }
    after(:create) do |warehouse, enumerator|
      if warehouse.teams.empty?
        warehouse.teams << create(:team)
      end
    end
  end

  factory :warehouse_item do
    warehouse
    sequence(:name) { |x| "Warehouse item #{x}" }
  end

  factory :warehouse_batch do
    association(:item, factory: :warehouse_item)
    price { rand(10) + 5 }
    total 10

    after(:create) do |batch, enumerator|
      create :warehouse_transaction, batch: batch, count: batch.total
    end
  end

  factory :warehouse_transaction do
    association(:batch, factory: :warehouse_batch)
    event
    returned 0
    count -1
    total -1
  end
end