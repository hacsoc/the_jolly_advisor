require 'rails_helper'

RSpec.describe ReviewVote, type: :model do
  describe 'relations' do
    it { should belong_to :review }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_numericality_of(:score).only_integer }
    it { should validate_inclusion_of(:score).in_array([-1, 1]) }
  end
end
