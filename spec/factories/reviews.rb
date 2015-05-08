FactoryGirl.define do
  factory :review do
    body { Forgery::Basic.text }

    association :course
    association :professor
    association :user
  end
end
