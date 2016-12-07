FactoryGirl.define do
  factory :talk do
    team
    sequence(:name) { |x| "Talk #{x}" }
    abstract 'Some Abstract'
    event_type
    user
    archived false
  end
end