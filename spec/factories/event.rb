FactoryGirl.define do
  factory :event do
    sequence(:name) { |x| "Event #{x}" }
    committed false
    approved false
    archived false
    begins_at { Time.current }
    ends_at { begins_at + 5.days }
    team
    association :owner, factory: :user
    event_type
    city
    location 'Some Location'
  end

  factory :event_type do
    sequence(:name) { |x| "Event Type #{x}" }
    team
    default false
  end
end