require 'rails_helper'

require 'sis_importer'

def text_double(text)
  double(text: text)
end

def meeting_double(schedule, room, professor, dates)
  meeting = double
  attributes = ['DaysTimes', 'Room', 'Instructor', 'MeetingDates']
  attributes.zip([schedule, room, professor, dates]).each do |attr, val|
    allow(meeting).to receive(:xpath).with(attr).and_return val
  end

  meeting
end

RSpec.describe SISImporter do
  describe '::process_course_instance' do
    let(:course_instance) { CourseInstance.new }
    let(:class_xml) { double(xpath: meetings) }
    let(:course_attributes) { {section: '', subtitle: '', dates: ['', '']} }

    let(:schedule) { text_double 'MWF' }
    let(:room) { text_double 'Glennan Lounge' }
    let(:professor) { text_double 'Andrew Mason' }
    let(:dates) { text_double '11/14/2017-11/16/2017' }

    context 'one meeting' do
      let(:meetings) { [@meeting] }
      before do
        @meeting = meeting_double(schedule, room, professor, dates)
      end

      context 'professor does not exist' do
        before { safe_delete_professors([professor.text]) }

        it 'creates a professor' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to change { Professor.count }.by 1
        end
      end

      context 'professor exists' do
        before { Professor.create(name: professor.text) }

        it 'does not create a professor' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to_not change { Professor.count }
        end
      end
    end

    context 'multiple meetings' do
      let(:meetings) { [@meeting1, @meeting2] }

      before do
        @meeting1 = meeting_double(schedule, room, professor, dates)
        @meeting2 = meeting_double(schedule, room, professor2, dates)
        safe_delete_professors([professor, professor2].map(&:text))
      end

      context 'different professors' do
        let(:professor2) { text_double(professor.text.swapcase) }

        it 'creates both professors' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to change { Professor.count }.by 2
        end

        it 'sets the primary professor to the first one' do
          SISImporter.process_course_instance(class_xml, course_instance, course_attributes)
          expect(course_instance.professor).to eq Professor.find_by(name: professor.text)

          course_instance = CourseInstance.new
          meetings.reverse!
          SISImporter.process_course_instance(class_xml, course_instance, course_attributes)
          expect(course_instance.professor).to eq Professor.find_by(name: professor2.text)
        end
      end

      context 'same professor' do
        let(:professor2) { professor }

        it 'creates one professor' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to change { Professor.count }.by 1
        end
      end
    end

    context 'no meetings' do
      let(:meetings) { [] }

      it 'sets the primary professor to TBA' do
        SISImporter.process_course_instance(class_xml, course_instance, course_attributes)
        expect(course_instance.professor).to eq Professor.TBA
      end

      context 'TBA prof exists' do
        before { expect(Professor.TBA).to_not be nil }

        it 'creates no professors' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to_not change { Professor.count }
        end
      end

      context 'TBA prof does not exist' do
        before { safe_delete_professors([Professor.TBA.name]) }

        it 'creates the TBA professor' do
          expect {
            SISImporter.process_course_instance(
              class_xml,
              course_instance,
              course_attributes,
            )
          }.to change { Professor.count }.by 1
        end
      end
    end
  end
end
