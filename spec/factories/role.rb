FactoryGirl.define do
  factory :role do
    sequence(:name) {|x| "Role #{x}" }
    team
  end
end