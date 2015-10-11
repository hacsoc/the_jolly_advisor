require 'rails_helper'

RSpec.describe CoursesHelper, type: :helper do
  describe '#course_linkify' do
    it 'returns text unchanged when there are no course names' do
      text = 'This definitely has no courses'
      expect(helper.course_linkify(text)).to eq text
    end

    it 'replaces course namse with links to their show pages' do
      text = 'Recommended preparation includes EECS 340, EECS 233'
      results = ['<a href="/courses/EECS340">EECS 340</a>',
                  '<a href="/courses/EECS233">EECS 233</a>']
      result_text = helper.course_linkify(text)
      results.each { |r| expect(result_text).to include r }
    end
  end

  describe '#prereq_sets' do
    it 'returns ["None"] for no prerequisites' do
      course = double(prerequisites: [])
      expect(helper.prereq_sets(course)).to eq %w(None)
    end

    it 'returns a list of prerequisite links joined by "or"s' do
      set1 = [double(to_param: '1'), double(to_param: '2')]
      set2 = [double(to_param: '3')]

      course = double(prerequisites: [set1, set2])
      result_set = [%{<a href="1">#{set1[0]}</a> or <a href="2">#{set1[1]}</a>},
                    %{<a href="3">#{set2[0]}</a>}]
      expect(helper.prereq_sets(course)).to eq result_set
    end
  end

  describe '#postreqs' do
    it 'returns ["None"] for no postrequisites' do
      course = double(postrequisites: [])
      expect(helper.postreqs(course)).to eq %w(None)
    end

    it 'returns a list of postrequisite links' do
      postreqs = [double(to_param: '1'), double(to_param: '2')]
      course = double(postrequisites: postreqs)
      result = [%{<a href="1">#{postreqs[0]}</a>},
                %{<a href="2">#{postreqs[1]}</a>}]
      expect(helper.postreqs(course)).to eq result
    end
  end
end
