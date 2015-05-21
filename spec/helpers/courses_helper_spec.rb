require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#first_professor' do
    before { @course = FactoryGirl.build(:course) }

    context 'when @course has no professors' do
      before do
        allow(@course).to receive(:professors) { [] }
        helper.instance_variable_set(:@course, @course)
      end

      it 'returns the TBA professor' do
        expect(helper.first_professor).to eq Professor.TBA
      end
    end

    context 'when @course has no real professors' do
      before do
        allow(@course).to receive(:professors) { [double(name: 'Staff'), double(name: 'TBA')] }
        helper.instance_variable_set(:@course, @course)
      end

      it 'returns the first fake professor' do
        expect(helper.first_professor.name).to eq 'Staff'
        expect(helper.first_professor.name).to_not eq 'TBA'
      end
    end

    context 'when @course has real professors' do
      before do
        allow(@course).to receive(:professors) do
          [double(name: 'Staff'), double(name: 'Real'), double(name: 'Staff'), double(name: 'Name')]
        end
        helper.instance_variable_set(:@course, @course)
      end

      it 'returns a real professor' do
        expect(helper.first_professor.name).to_not eq 'Staff'
        expect(helper.first_professor.name).to_not eq 'TBA'
      end

      it 'returns the first real professor' do
        expect(helper.first_professor.name).to eq 'Real'
        expect(helper.first_professor.name).to_not eq 'Name'
      end
    end
  end

  describe '#course_linkify' do
    context 'when the text has nothing that looks like a course' do
      it 'should return the same text' do
        text = 'This definitely has no courses'
        expect(helper.course_linkify(text)).to eq text
      end
    end

    context 'when the text has something that looks like a course' do
      before do
        @text = 'Recommended preparation includes EECS 340, EECS 233'
        @results = ['<a href="/courses/EECS340">EECS 340</a>',
                    '<a href="/courses/EECS233">EECS 233</a>']
      end

      it 'should replace those courses with links to their show pages' do
        result_text = helper.course_linkify(@text)
        @results.each { |r| expect(result_text).to include r }
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
