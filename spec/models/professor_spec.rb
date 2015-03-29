require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe '.TBA', slow: true do
    context 'when called the first time' do
      before { Professor.where(name: 'TBA').destroy_all }

      it 'creates a TBA record' do
        expect(Professor.where(name: 'TBA').count).to eq 0
        Professor.TBA
        expect(Professor.where(name: 'TBA').count).to eq 1
      end
    end

    context 'when it has already been called' do
      before { Professor.TBA }

      it 'does not create a new record' do
        old_count = Professor.count
        Professor.TBA
        expect(Professor.count).to eq old_count
      end
    end

    it 'returns the record' do
      tba = Professor.TBA
      expect(tba.class).to eq Professor
      expect(tba.name).to eq 'TBA'
    end
  end
end
