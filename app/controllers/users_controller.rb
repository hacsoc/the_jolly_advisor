class UsersController < ApplicationController
  before_action CASClient::Frameworks::Rails::Filter, only: [:login]

  def login
    redirect_to params[:was_at] || root_path
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
