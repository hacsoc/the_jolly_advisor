require 'rails_helper'
require 'sis_importer'

RSpec.describe SISImporter do
  describe '::import_sis' do
    it 'imports stuff from SIS' do
      VCR.use_cassette 'sis-dump' do
        SISImporter.import_sis
      end
    end
  end
end
