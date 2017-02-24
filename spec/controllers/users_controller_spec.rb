require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #login' do
    before { fake_cas }

    it 'redirects to root path by default' do
      get :login
      expect(response).to redirect_to root_path
    end

    it 'redirects to the specified url' do
      url = '/somewhere'
      get :login, was_at: url
      expect(response).to redirect_to url
    end
  end

  describe 'GET #logout' do
    let(:cas) { CASClient::Frameworks::Rails::Filter }
    let(:cas_session) { {cas_user: 'bob'} }

    it 'logs the user out' do
      expect(cas).to receive(:logout).and_call_original
      get :logout, {}, cas_session
    end
  end
end
