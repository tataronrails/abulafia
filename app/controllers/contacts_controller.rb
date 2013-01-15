class ContactsController < ApplicationController
  skip_authorization_check

  before_filter :check_access

  def index
    @users = User.order(:login)
    @user = User.new
  end


  def add_new_comment
    comment = params[:user][:comment]
    user_id = params[:user_id]

    user = User.find(params[:user_id])

    user.discussion.comments.create(:comment => comment, :user_id => user_id)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        render :partial => user.discussion.comments
      }
    end
  end


  def create_virtual_user

    #unless params[:user][:login].present?
    #  redirect_to :back, :notice => "Error" and return
    #end

    params[:user][:password] = Devise.friendly_token.first(8)
    user = User.new(params[:user])

    if user.save
      flash[:notice] = "ok"
    else
      #raise user.errors.to_json
      flash[:errors] = user.errors
    end

    redirect_to :back
  end

  def show
    @user = User.find(params[:id])

    unless @user.discussion
      @user.create_discussion!(:title => "Discussion by: #{@user.login}")
    end
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
    unless ["almazomru@gmail.com", "e.acoolova@gmail.com", "mirzayanovti@gmail.com", "hama.deev@gmail.com"].include? current_user.email

      flash[:notice] = "You have no access to see contacts"
      redirect_to root_path
    end
  end
end
