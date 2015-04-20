FactoryGirl.define do
  factory :course_instance do
    start_date { Date.today.beginning_of_week }
    end_date { Date.today.end_of_week }

    association :professor
  end
end
