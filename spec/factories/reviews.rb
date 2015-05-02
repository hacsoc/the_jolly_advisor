FactoryGirl.define do
  factory :review do
    body { Forgery::Basic.text }
    helpfulness { Forgery::Basic.number }

    association :course
    association :professor
    association :user
  end
end
