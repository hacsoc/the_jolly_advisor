require 'rails_helper'

RSpec.describe SchedulerHelper, type: :helper do
  describe '#scheduler_feed' do
    context 'when params does not have the semester key' do
      before { controller.params.delete(:semester) }

      it 'should return the path to the scheduler index action' do
        expect(helper.scheduler_feed).to eq '/scheduler'
      end
    end

    context 'when params has the semester key' do
      before { controller.params[:semester] = 'fall' }

      it 'should return the path to the scheduler index with the semester as a query param' do
        expect(helper.scheduler_feed).to eq '/scheduler?semester=fall'
      end
    end
  end

  describe '#course_instance_autocomplete' do
    context 'when passed a date' do
      it 'should return the path to course instance autocomplete with that date as a query param' do
        expect(helper.course_instance_autocomplete(Date.new(2015, 4, 24))).to eq(
          '/course_instances/autocomplete?current_date=2015-04-24')
      end
    end

    context 'when not passed a date' do
      it 'should return the autocomplete path with today as a query param' do
        date_str = Date.today.strftime('%Y-%m-%d')
        expect(helper.course_instance_autocomplete).to eq(
          "/course_instances/autocomplete?current_date=#{date_str}")
      end
    end
  end
end
