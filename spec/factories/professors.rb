FactoryGirl.define do
  factory :professor do
    name { Forgery('basic').text }
  end
end
