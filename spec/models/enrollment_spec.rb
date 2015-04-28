require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  it { should belong_to :user }
  it { should belong_to :course_instance }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :course_instance_id }
end
