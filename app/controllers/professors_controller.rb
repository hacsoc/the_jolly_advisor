class ProfessorsController < ApplicationController
  def autocomplete
    @professors = Professor.search(params[:term])
    respond_to do |format|
      format.json do
        render json: @professors.map { |p| { id: p.id, label: p.name } }
      end
    end
  end
end
