require 'rails_helper'

RSpec.describe CourseInstance, type: :model do
  before do
    @course_instance_yesterday = FactoryGirl.build(:course_instance, end_date: Date.today-1)
    @course_instance_today = FactoryGirl.build(:course_instance, end_date: Date.today)
    @course_instance_tomorrow = FactoryGirl.build(:course_instance, end_date: Date.today+1)
  end

  describe ".schedulable?" do
    it "should return true if the class hasn't ended yet" do
      expect(@course_instance_tomorrow.schedulable?).to be true
    end

    it "should return false if the class has ended" do
      expect(@course_instance_yesterday.schedulable?).to be false

    end

    it "should return false if the class ends today" do
      expect(@course_instance_today.schedulable?).to be false
    end
  end

end