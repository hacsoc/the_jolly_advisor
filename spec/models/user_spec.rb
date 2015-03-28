require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :wishlist }
  it { should have_many :enrollments }
  it { should have_many :enrolled_courses }
end
