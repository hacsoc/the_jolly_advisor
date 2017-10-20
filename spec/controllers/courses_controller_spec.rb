require 'rails_helper'
require 'factory_girl_rails'

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
    it 'does a 404 when the course cannot be found' do
      allow(Course).to receive(:find_by).and_return(nil)
      expect { get :show, params: {id: 'EECS395'} }
        .to raise_error(ActionController::RoutingError)
    end

    it 'sets the course in the view' do
      course = spy
      allow(Course).to receive(:find_by).and_return(course)
      get :show, params: {id: 'EECS395'}
      expect(assigns(:course)).to eq course
    end

    context '.json' do
      render_views

      it 'renders' do
        course = FactoryGirl.create(:course)
        get :show, params: {id: course.to_param}, format: :json
        expected_keys = [
          'id',
          'department',
          'course_number',
          'description',
          'course_offering',
          'created_at',
          'updated_at',
        ].sort
        expect(response.success?).to be true
        expect(JSON.parse(response.body).keys.sort).to eq expected_keys
      end
    end
  end
end
