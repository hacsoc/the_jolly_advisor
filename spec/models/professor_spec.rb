require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe '::TBA', slow: true do
    it 'creates a TBA record when called the first time' do
      Professor.where(name: 'TBA').destroy_all
      expect{ Professor.TBA }.to change{ Professor.count }.by(1)
    end

    it 'does not create a new record when it has already been called' do
      Professor.TBA
      expect{ Professor.TBA }.to_not change{ Professor.count }
    end
  end
end
