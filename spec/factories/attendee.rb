FactoryGirl.define do
  factory :attendee do
    user
    event
    attendee_type
  end

  factory :attendee_type do
    team
  end
end