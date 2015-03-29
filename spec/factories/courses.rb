FactoryGirl.define do
  factory :course do
    department "EECS"
    course_number 132
    title "Intro to Java"

    trait :with_prereqs do
      transient do
        number_of_prereqs 2
      end

      after :create do |course, evaluator|
        prereqs = FactoryGirl.create_list(:course, evaluator.number_of_prereqs)
        Prerequisite.create(postreq_id: course.id, prereq_ids: prereqs.map(&:id))
      end
    end
  end
end
