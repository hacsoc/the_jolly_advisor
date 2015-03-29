FactoryGirl.define do
  factory :prerequisite do
    association :postrequisite, factory: :course

    prerequisite_ids FactoryGirl.create_list(:course, 3).map(&:id)
  end
end