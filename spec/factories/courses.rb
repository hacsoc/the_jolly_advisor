FactoryGirl.define do
  factory :course do
    department { Forgery(:basic).text(allow_numeric: false)[0...4].upcase }
    course_number { Forgery(:basic).number*100 }
    title { Forgery(:basic).text(allow_numeric: false) }
    description { Forgery(:basic).text(allow_numeric: false) }

    trait :with_prereqs do
      transient do
        number_of_prereqs 2
      end

      after :create do |course, evaluator|
        prereqs = FactoryGirl.create_list(:course, evaluator.number_of_prereqs)
        Prerequisite.create(postreq_id: course.id, prereq_ids: prereqs.map(&:id))
      end
    end

    trait :with_course_instance do
      after :create do |course, _evaluator|
        FactoryGirl.create(:course_instance, course: course)
      end
    end
  end
end
