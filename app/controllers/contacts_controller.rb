class ContactsController < ApplicationController
  skip_authorization_check

  before_filter :check_access

  def index
    @users = User.order(:login)
  end

  def show
    @user = User.find(params[:id])
    @invitation_accepted_list = User.invitation_accepted.map(&:email)
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      flash[:notice] = "User was destroyed!"
    end

    respond_to do |format|
      format.html { redirect_to contacts_list_path }
    end
  end


  private
  def check_access
    unless ["almazomru@gmail.com","e.acoolova@gmail.com", "mirzayanovti@gmail.com", "hama.deev@gmail.com"].include? current_user.email

      flash[:notice] = "You have no access to see contacts"
      redirect_to root_path
    end
  end
end