class ContactsController < ApplicationController
  skip_authorization_check

  def index
    @users = User.order("first_name ASC")
  end

  def show
    @user = User.find(params[:id])
  end
end
