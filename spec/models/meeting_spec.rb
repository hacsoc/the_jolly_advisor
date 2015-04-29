require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it { should belong_to :course_instance }
  it { should belong_to :professor }

  describe '#scheduled_meetings' do
    context 'when the schedule is TBA' do
      let(:meeting) { FactoryGirl.build(:meeting, :tba) }

      it 'returns an empty array' do
        expect(meeting.scheduled_meetings.empty?).to be true
      end
    end

    context 'when the meeting times are MWF' do
      let(:meeting) { FactoryGirl.build(:meeting, schedule: 'MWF 10:00 AM - 10:50 AM') }

      it 'returns three scheduled meetings' do
        expect(meeting.scheduled_meetings.size).to eq 3
      end

      it 'returns meetings for the current mon, wed, fri at the given time' do
        # 0, 2 and 4 are how far Monday, Wednesday and Friday are into the given week
        dates = [0, 2, 4].map { |n| DateTime.now.at_beginning_of_week + n.days }
        start_times = dates.map { |d| d.advance(hours: 10) }
        end_times = dates.map { |d| d.advance(hours: 10, minutes: 50) }

        meeting.scheduled_meetings.zip(start_times, end_times).each do |scheduled_meeting, start_time, end_time|
          expect(scheduled_meeting.start_time).to eq start_time
          expect(scheduled_meeting.end_time).to eq end_time
        end
      end
    end
  end
end
