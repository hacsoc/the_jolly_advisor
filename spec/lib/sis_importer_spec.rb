require 'rails_helper'

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

  describe '::process_term' do
    let(:xml) { double(xpath: []) }
    let(:term_info) { double(semester: 'Fall', year: '2015') }

    before do
      Semester.destroy_all(
        semester: term_info.semester,
        year: term_info.year
      )
    end

    it 'creates a new semester if needed' do
      expect do
        SISImporter.process_term(xml, term_info)
      end.to change { Semester.count }.by 1
    end

    it 'does not create duplicate semesters' do
      Semester.create(
        semester: term_info.semester,
        year: term_info.year
      )
      expect do
        SISImporter.process_term(xml, term_info)
      end.to_not change { Semester.count }
    end
  end

  describe '::fetch_title_and_subtitle' do
    before { @result = SISImporter.fetch_title_and_subtitle(full_title) }

    context 'for special topics courses' do
      let(:full_title) { 'Special Topics: Name of Course' }

      it "sets the title to 'Special Topics'" do
        expect(@result[:title]).to eq 'Special Topics'
      end

      it 'sets the subtitle to what comes after the colon' do
        expect(@result[:subtitle]).to eq 'Name of Course'
      end
    end

    context 'for regular courses' do
      let(:full_title) { 'Regular Course' }

      it 'does not return a subtitle' do
        expect(@result[:subtitle]).to be nil
      end

      it 'returns the full title' do
        expect(@result[:title]).to eq full_title
      end
    end
  end

  describe '::fetch_start_end_dates' do
    let(:date_string) { '1/14/2015 - 2/16/2015' }

    it 'returns a list of dates' do
      dates = SISImporter::fetch_start_end_dates(date_string)
      expect(dates[0]).to eq Date.new(2015, 1, 14)
      expect(dates[1]).to eq Date.new(2015, 2, 16)
    end
  end
end
