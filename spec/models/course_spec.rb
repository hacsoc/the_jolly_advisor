require 'rails_helper'

RSpec.describe Course, type: :model do
  before do
    @course = FactoryGirl.build(:course, department: "EECS", course_number: 132)
    @course.course_instances = [FactoryGirl.build(:course_instance, :end_date => Date.today - 1),
                                FactoryGirl.build(:course_instance, :end_date => Date.today + 365)]
    # Testing unhappy paths
    @course_bad = FactoryGirl.build(:course, department: 132, course_number: "EECS")
  end

  describe ".postrequisites" do
    it "should return all postrequisites for the course" do
      prereq = FactoryGirl.create(:course, department: "EECS", course_number: 233)
      postreq = FactoryGirl.create(:course, department: "EECS", course_number: 131)
      FactoryGirl.create(:prerequisite, postrequisite: postreq, prerequisite_ids: [prereq.id])
      expect(prereq.postrequisites).to eq [postreq]
    end
  end

  describe ".prerequisites" do
    it "should return all prerequisites for the course" do
      postreq = FactoryGirl.create(:course, department: "EECS", course_number: 131)
      prereqs = FactoryGirl.create_list(:course, 3)
      FactoryGirl.create(:prerequisite, postrequisite: postreq, prerequisite_ids: prereqs.map(&:id))
      expect(postreq.prerequisites).to eq [prereqs]
    end
  end

  describe ".schedulable?" do
    it "should say the class is schedulable" do
      expect(@course.schedulable?).to be true
    end
  end

  describe ".to_param" do
    it "should return a spaceless version of to_s" do
      expect(@course.to_param).to eq @course.to_s.gsub(' ', '')
    end
  end

  describe ".to_s" do
    it "should return a string of the department and the course number" do
      expect(@course.to_s).to eq "EECS 132"
    end
  end

  describe ".long_string" do
    it "should return a long description" do
      expect(@course.long_string).to match /[A-Z]{4}\s[\d]{3,4}:\s/
    end
  end
end
