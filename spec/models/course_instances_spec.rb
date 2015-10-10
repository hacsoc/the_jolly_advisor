require 'rails_helper'

RSpec.describe CourseInstance, type: :model do
  it { should belong_to :semester }
  it { should belong_to :course }
  it { should belong_to :professor }

  it { should have_many :meetings }
  it { should have_many :enrollments }
  it { should have_many(:enrolled_students).through(:enrollments) }

  describe '#schedulable?' do
    before(:all) { @course_instance = CourseInstance.new }

    it "returns true if the class hasn't ended yet" do
      @course_instance.end_date = Date.today + 1
      expect(@course_instance.schedulable?).to be true
    end

    it "returns false if the class has ended" do
      @course_instance.end_date = Date.today - 1
      expect(@course_instance.schedulable?).to be false
    end

    it "returns false if the class ends today" do
      @course_instance.end_date = Date.today
      expect(@course_instance.schedulable?).to be false
    end
  end

  describe '#schedule' do
    before do
      @course_instance = CourseInstance.new
      allow(@course_instance).to receive(:meetings).and_return meetings
    end

    context 'when there are no meetings' do
      let(:meetings) { [] }

      it 'returns "TBA"' do
        expect(@course_instance.schedule).to eq 'TBA'
      end
    end

    context 'when there are meetings' do
      let(:meetings) { [double(schedule: 'MW 10:00 AM - 10:50 AM')] * 2 }

      it 'returns the meeting schedules separated by a ;' do
        expect(@course_instance.schedule).to eq 'MW 10:00 AM - 10:50 AM; MW 10:00 AM - 10:50 AM'
      end
    end
  end
end
