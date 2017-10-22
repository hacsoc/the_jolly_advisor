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

  describe 'GET show' do
    context 'when the course cannot be found' do
      before { allow(Course).to receive(:find_by).and_return nil }

      it 'does a 404' do
        expect { get :show, params: {id: 'EECS395'} }
          .to raise_error(ActionController::RoutingError)
      end
    end

    it 'sets the course in the view' do
      course = spy
      allow(Course).to receive(:find_by).and_return(course)
      get :show, params: {id: 'EECS395'}
      expect(assigns(:course)).to eq course
    end
  end
end
