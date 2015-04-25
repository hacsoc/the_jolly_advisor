require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#current_user' do
    it 'should return the value of @current_user' do
      helper.instance_variable_set(:@current_user, 10)
      expect(helper.current_user).to eq 10
 
      helper.instance_variable_set(:@current_user, nil)
      expect(helper.current_user).to be nil
    end
  end

  describe '#user_signed_in?' do
    context 'when @current_user is present' do
      before { helper.instance_variable_set(:@current_user, 'a') }

      it 'should return true' do
        expect(helper.user_signed_in?).to be true
      end
    end

    context 'when @current_user is not present' do
      before { helper.instance_variable_set(:@current_user, nil) }

      it 'should return false' do
        expect(helper.user_signed_in?).to be false
      end
    end
  end

  describe '#full_title' do
    context 'when passed no arguments' do
      it 'should return "The Jolly Advisor"' do
        expect(helper.full_title).to eq 'The Jolly Advisor'
      end
    end

    context 'when passed a non-empty argument' do
      it 'should return the argument joined with "The Jolly Advisor"' do
        expect(helper.full_title('foo')).to eq 'foo|The Jolly Advisor'
      end
    end

    context 'when passed an empty argument' do
      it 'should return "The Jolly Advisor"' do
        expect(helper.full_title('')).to eq 'The Jolly Advisor'
      end
    end
  end
end
