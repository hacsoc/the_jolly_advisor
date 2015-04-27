require 'rails_helper'

RSpec.describe ProfessorsHelper, type: :helper do
  describe '#professor_search_link' do
    it 'should return a link to the course search for that professor' do
      professor = double(name: 'foo')
      result = '<a href="/courses?professor=foo">foo</a>'
      expect(helper.professor_search_link(professor)).to eq result
    end
  end
end
