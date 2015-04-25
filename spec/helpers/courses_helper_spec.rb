require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#first_professor' do
    context 'when @course has no course instances' do
      before do
        course = double(course_instances: [])
        helper.instance_variable_set(:@course, course)
      end

      it 'should return the TBA professor' do
        expect(helper.first_professor).to eq Professor.TBA
      end
    end

    context 'when @course has one course instance' do
      before do
        course = double(course_instances: [double(professor: 'prof')])
        helper.instance_variable_set(:@course, course)
      end

      it 'should return the professor of that instance' do
        expect(helper.first_professor).to eq 'prof'
      end
    end

    context 'when @course has multiple instances' do
      before do
        @instances = (1..3).map { |n| double(professor: "prof#{n}") }
        course = double(course_instances: @instances)
        helper.instance_variable_set(:@course, course)
      end

      it 'should return the professor of the first instance' do
        expect(helper.first_professor).to eq @instances.first.professor
      end

      it 'should not return the professor of any of the other instances' do
        prof = helper.first_professor
        expect(@instances[1..-1].any? { |i| i.professor == prof }).to be false
      end
    end
  end

  describe '#prereq_sets' do
    context 'when the course has no prerequisites' do
      before { @course = double(prerequisites: []) }

      it 'should return an array containing "None"' do
        expect(helper.prereq_sets(@course)).to eq %w(None)
      end
    end

    context 'when the course has prerequisites' do
      before do
        @set1 = [double(to_param: '1'), double(to_param: '2')]
        @set2 = [double(to_param: '3')]

        @course = double(prerequisites: [@set1, @set2])
      end

      it 'should return a list of links joined by "or"s' do
        result_set = [%{<a href="1">#{@set1[0]}</a> or <a href="2">#{@set1[1]}</a>},
                      %{<a href="3">#{@set2[0]}</a>}]
        expect(helper.prereq_sets(@course)).to eq result_set
      end
    end
  end

  describe '#postreqs' do
    context 'when the course has no postrequisites' do
      before { @course = double(postrequisites: []) }

      it 'should return an array containing "None"' do
        expect(helper.postreqs(@course)).to eq %w(None)
      end
    end

    context 'when the course has postrequisites' do
      before do
        @postreqs = [double(to_param: '1'), double(to_param: '2')]
        @course = double(postrequisites: @postreqs)
      end

      it 'should return a list of links' do
        result = [%{<a href="1">#{@postreqs[0]}</a>},
                  %{<a href="2">#{@postreqs[1]}</a>}]
        expect(helper.postreqs(@course)).to eq result
      end
    end
  end
end
