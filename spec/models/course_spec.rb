require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should have_many :course_instances }
  it { should have_many(:professors).through(:course_instances) }

  describe '::filter_by_name' do
    it 'searches on the name' do
      courses = [double]
      allow(Course).to receive(:search).and_return(courses)
      expect(Course.filter_by_name('search')).to eq courses
    end

    it 'does not filter when there is nothing to filter on' do
      all_courses = [double]
      allow(Course).to receive(:all).and_return(all_courses)
      actual = Course.filter_by_name(nil)
      expect(actual).to eq all_courses
    end
  end

  describe '::filter_by_semester' do
    it 'does not filter when there is nothing to filter on' do
      all_courses = [double]
      allow(Course).to receive(:all).and_return(all_courses)
      actual = Course.filter_by_semester(nil)
      expect(actual).to eq all_courses
    end
  end

  describe '::filter_by_professor' do
    it 'does not filter when there is nothing to filter on' do
      all_courses = [double]
      allow(Course).to receive(:all).and_return(all_courses)
      actual = Course.filter_by_professor(nil)
      expect(actual).to eq all_courses
    end
  end

  before(:all) do
    @course = FactoryGirl.build(:course, department: "EECS", course_number: 132)
    @course.course_instances = [FactoryGirl.build(:course_instance, end_date: Date.today - 1),
                                FactoryGirl.build(:course_instance, end_date: Date.today + 365)]
    @course.save
    # Testing unhappy paths
    @course_bad = FactoryGirl.build(:course, department: 132, course_number: "EECS")
  end

  describe "#postrequisites" do
    it "should return all postrequisites for the course" do
      prereq = Course.new
      postreq = @course
      allow(Prerequisite).to receive(:where).and_return(double(pluck: [postreq.id]))
      expect(prereq.postrequisites).to eq [postreq]
    end
  end

  describe "#prerequisites" do
    it "should return all prerequisites for the course" do
      prereq = @course
      postreq = Course.new
      allow(Prerequisite).to receive(:where).and_return([double(prerequisite_ids: [prereq.id])])
      expect(postreq.prerequisites.to_a).to eq [[prereq]]
    end
  end

  describe '#real_professors' do
    before { @course = FactoryGirl.build(:course) }

    context 'when all professors are "Staff"' do
      before { allow(@course).to receive(:professors) { [double(name: 'Staff')] } }

      it 'returns an empty array' do
        expect(@course.real_professors).to eq []
      end
    end

    context 'when all professors are "TBA"' do
      before { allow(@course).to receive(:professors) { [double(name: 'TBA')] } }

      it 'returns an empty array' do
        expect(@course.real_professors).to eq []
      end
    end

    context 'when some professors have real names' do
      before do
        allow(@course).to receive(:professors) do
          [double(name: 'Staff'),
           double(name: 'Real Name')]
        end
      end

      it 'returns a subset of the professors' do
        expect(@course.real_professors.length).to eq 1
      end

      it 'returns only the professors with real names' do
        @course.real_professors.each do |p|
          expect(p.name).to_not eq 'Staff'
          expect(p.name).to_not eq 'TBA'
        end
      end
    end

    context 'when all professors have real names' do
      before do
        allow(@course).to receive(:professors) do
          [double(name: 'Real'),
           double(name: 'Name')]
        end
      end

      it 'returns the array of professors' do
        expect(@course.real_professors.map(&:name)).to eq @course.professors.map(&:name)
      end
    end
  end

  describe "#schedulable?" do
    it "should say the class is schedulable" do
      expect(@course.schedulable?).to be true
    end
  end

  describe '#score' do
    let(:course) do
      FactoryGirl.build(:course, department: 'EECS', course_number: 132, title: 'Intro to Java')
    end

    context 'with no word-level exact matches' do
      it 'returns 0' do
        expect(course.score('no match')).to eq 0
      end

      it 'returns 0' do
        expect(course.score('jav')).to eq 0
      end
    end

    context 'with some word-level matches' do
      it 'returns the number of matches' do
        expect(course.score('EECS Java')).to eq 2
      end

      it 'returns the number of matches even for "insignificant" words' do
        expect(course.score('132 to')).to eq 2
      end
    end
  end

  describe "#to_param" do
    it "should return a spaceless version of to_s" do
      expect(@course.to_param).to eq @course.to_s.gsub(' ', '')
    end
  end

  describe "#to_s" do
    it "should return a string of the department and the course number" do
      expect(@course.to_s).to eq "EECS 132"
    end
  end

  describe "#long_string" do
    it "should return a long description" do
      expect(@course.long_string).to match /[A-Z]{4}\s[\d]{3,4}:\s/
    end
  end
end
