FactoryGirl.define do
  factory :user do
    transient do
      teams []
      roles []
    end
    
    sequence(:name) { |x| "User #{x}" }
    email { "#{name}@evman.dev"}
    password { SecureRandom.hex }
    
    after(:create) do |user, evaluator|
      evaluator.teams.each do |team|
        create(:team_membership, user: user, team: team)
      end

      evaluator.roles.each do |role|
        user.roles << role
      end
    end
  end
end