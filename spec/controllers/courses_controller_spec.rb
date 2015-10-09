require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe 'GET index' do
    it 'sets the semesters in the view' do
      semesters = double
      allow(Semester).to receive(:all).and_return(semesters)
      get :index
      expect(assigns(:semesters)).to eq semesters
    end
  end
end
