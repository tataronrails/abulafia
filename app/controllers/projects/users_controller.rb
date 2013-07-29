class UsersController < InheritedResources
  belongs_to :project
  actions :index

  def index
    @project = Project.find(params[:project_id])
    @users = @project.users

    @list_of_roles = ProjectMembership.role.values
    list_of_all_users_emails = User.all.map(&:email)

    users_still_in_project = @project.users.map(&:email)
    @list_of_all_users_emails = list_of_all_users_emails.delete_if { |u| users_still_in_project.include?(u) }
    @invitation_accepted_list = User.invitation_accepted.map(&:email)
  end

end
