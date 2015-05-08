FactoryGirl.define do
  factory :review_vote do
    sequence(:score) { |n| (-1)**n }

    association :review
    association :user
  end
end
