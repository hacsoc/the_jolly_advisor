require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :wishlist }
  it { should have_many :enrollments }
  it { should have_many(:enrolled_courses).through(:enrollments) }

  describe '#to_s' do
    before { @user = FactoryGirl.build(:user) }

    it 'return the case_id as a string' do
      expect(@user.to_s).to eq @user.case_id.to_s
    end
  end
end
