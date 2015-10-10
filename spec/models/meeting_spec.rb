require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it { should belong_to :course_instance }
  it { should belong_to :professor }

  describe '#scheduled_meetings' do
    context 'when the schedule is TBA' do
      let(:meeting) { Meeting.new schedule: 'TBA' }

      it 'returns an empty array' do
        expect(meeting.scheduled_meetings.empty?).to be true
      end
    end

    context 'when the meeting times are MWF' do
      let(:meeting) { Meeting.new schedule: 'MWF 10:00 AM - 10:50 AM' }

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

  describe '#autocomplete_label' do
    let(:meeting) { Meeting.new schedule: schedule }
    let(:course_instance) { double(course: double(long_string: 'ls')) }
    let(:schedule) { '1234' }
    before { allow(meeting).to receive(:course_instance).and_return(course_instance) }

    it 'has the course string for the title' do
      expect(meeting.autocomplete_label).to start_with 'ls'
    end

    it 'has the schedule in parens' do
      expect(meeting.autocomplete_label).to end_with '(1234)'
    end

    context 'with no schedule' do
      let(:schedule) { nil }

      it 'has TBA for the schedule' do
        expect(meeting.autocomplete_label).to end_with '(TBA)'
      end
    end
  end
end
