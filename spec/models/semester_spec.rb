require 'rails_helper'

RSpec.describe Semester, type: :model do
  describe '#to_s' do
    let(:semester) { FactoryGirl.build(:semester, semester: 'Fall', year: 2015) }

    it 'returns the semester and year with a space' do
      expect(semester.to_s).to eq 'Fall 2015'
    end
  end
end
