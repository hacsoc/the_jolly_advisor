require 'rails_helper'

RSpec.describe "reviews/show", type: :view do
  before(:each) do
    @review = assign(:review, Review.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
