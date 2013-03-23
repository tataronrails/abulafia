class Projects::UsersController < ItemsController
  belongs_to :project

  load_and_authorize_resource :project
  load_and_authorize_resource :user, :through => :project

  actions :index

  def index
    ### TODO переделать
    list_of_all_users_emails = User.pluck(:email)
    users_still_in_project = @project.users.pluck(:email)
    @list_of_all_users_emails = list_of_all_users_emails - users_still_in_project
    @invitation_accepted_list = User.invitation_accepted.pluck(:email)
    ###
    index!
  end
end