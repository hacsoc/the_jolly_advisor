FactoryBot.define do
  factory :user do
    sequence(:case_id) { |n| "abc#{n}" }
  end
end
