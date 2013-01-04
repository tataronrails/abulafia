class ContactsController < ApplicationController
  skip_authorization_check

  def index
    @users = User.order(:login)
  end

  def show
    @user = User.find(params[:id])
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
end
