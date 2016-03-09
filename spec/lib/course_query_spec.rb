require 'course_query'

RSpec.describe CourseQuery do
  describe '#score' do
    let(:course) { double(to_s: 'EECS 132', title: 'Intro to the Java') }
    let(:course_query) { CourseQuery.new(course) }

    it 'returns the number of word-level matches' do
      expect(course_query.score('no match')).to eq 0
    end

    it 'does not count partial matches' do
      expect(course_query.score('Jav')).to eq 0
    end

    it 'counts exact matches' do
      expect(course_query.score('EECS Java')).to eq 2
    end

    it 'counts "insignificant" words' do
      expect(course_query.score('132 to the')).to eq 3
    end

    it 'counts out of order matches' do
      expect(course_query.score('Java the to Intro')).to eq 4
    end
  end
end
