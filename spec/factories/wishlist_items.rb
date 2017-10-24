FactoryBot.define do
  factory :wishlist_item do
    association :course
    association :user
  end
end
