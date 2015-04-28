require 'rails_helper'

RSpec.describe CourseInstance, type: :model do
  it { should belong_to :semester }
  it { should belong_to :course }
  it { should belong_to :professor }

  it { should have_many :meetings }
  it { should have_many :enrollments }
  it { should have_many(:enrolled_students).through(:enrollments) }

  before do
    @course_instance_yesterday = FactoryGirl.build(:course_instance, end_date: Date.today - 1)
    @course_instance_today = FactoryGirl.build(:course_instance, end_date: Date.today)
    @course_instance_tomorrow = FactoryGirl.build(:course_instance, end_date: Date.today + 1)
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

  describe '#schedule' do
    context 'when there are no meetings' do
      let(:course_instance) { FactoryGirl.build(:course_instance) }

      it 'returns "TBA"' do
        expect(course_instance.schedule).to eq 'TBA'
      end
    end

    context 'when there are meetings' do
      let(:meetings) { FactoryGirl.build_list(:meeting, 2, schedule: 'MW 10:00 AM - 10:50 AM') }
      let(:course_instance) { FactoryGirl.build(:course_instance, meetings: meetings) }

      it 'returns the meeting schedules separated by a ;' do
        expect(course_instance.schedule).to eq 'MW 10:00 AM - 10:50 AM; MW 10:00 AM - 10:50 AM'
      end
    end
  end
end
