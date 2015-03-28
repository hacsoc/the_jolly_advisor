require 'simplecov'
SimpleCov.start

describe User, '.to_s' do
  user = #Create test user
  expect(user.to_s).to eq "slh74@case.edu"
end

