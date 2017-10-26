FactoryBot.define do
  factory :prerequisite do
    association :postrequisite, factory: :course

    prerequisite_ids FactoryBot.create_list(:course, 3).map(&:id)
  end
end
