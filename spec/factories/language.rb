FactoryGirl.define do
  factory :language do
    sequence(:name) {|x| "Language #{x}"}
    code "en"
  end
end