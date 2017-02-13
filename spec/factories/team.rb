FactoryGirl.define do
  factory :team do
    sequence(:name) { |x| "Team #{x}" }
    description { "#{name} - description"}
    system false
    add_attribute(:public) { false }
  end

  factory :team_membership do
    user
    team
    active true
  end

  factory :team_invitation do
    email 'user@example.com'
    code { SecureRandom.hex }
    team
  end
end