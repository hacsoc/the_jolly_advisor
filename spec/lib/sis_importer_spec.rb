require 'lib_helper'

# SISImporter requires these implicitly through the Rails env, but we're being
# specific here so we don't have to load all of rails.
require_relative '../../config/initializers/patches/array'
require 'active_record'

require 'sis_importer'

RSpec.describe SISImporter do
  describe '::fetch_term_info' do
    let(:xml) { double(xpath: double(text: 'Fall 2015')) }

    it 'gets the semester and year from the xml' do
      term_info = SISImporter.fetch_term_info xml
      expect(term_info.semester).to eq 'Fall'
      expect(term_info.year).to eq '2015'
    end
  end
end
