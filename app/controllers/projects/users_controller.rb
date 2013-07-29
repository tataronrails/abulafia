class Projects::UsersController < InheritedResources::Base
  belongs_to :project
  actions :index, :create, :destroy
  custom_actions resource: :reinvite
  skip_authorization_check

  def index
    @project = Project.find(params[:project_id])
    @users = @project.users

    @list_of_roles = ProjectMembership.role.values
    list_of_all_users_emails = User.all.map(&:email)

    users_still_in_project = @project.users.map(&:email)
    @list_of_all_users_emails = list_of_all_users_emails.delete_if { |u| users_still_in_project.include?(u) }
    @invitation_accepted_list = User.invitation_accepted.map(&:email)
  end

  #invite
  def create
    rate = params[:project_user][:rate]
    type_of_work = params[:project_user][:type_of_hours_calculation].to_i

    a = %W(Hourly Fixed Percentage)
    type_of_work_name = a[type_of_work]




    if params[:invitation][:email].blank?
      redirect_to :back, :notice => "Email field can not be blank!" and return
    end

    email = params[:invitation][:email]
    #first_name = params[:invitation][:first_name]
    #second_name = params[:invitation][:second_name]
    role = params[:role]
    user = User.where(:email => email).first

    project = Project.find(params[:project_id])

    if User.where(:email => email).exists?
      pm = ProjectMembership.new(:user => user, :project => project, :role => role, :rate => rate, :type_to_calculate => type_of_work_name)


      if pm.save
        flash[:notice] = "User now can see current project"

        client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
        message = "Invited existed user <b>#{user.fio}</b> to project as #{role}"

        begin
          client[project.name].send('abulafia', message, :color => 'yellow', :notify => false)
        rescue HipChat::UnknownRoom
          client['abulafia'].send('abulafia', "No room #{project.name}", :color => 'red', :notify => true)

        end


      else
        raise pm.erors.to_json
      end
    else
      #User not exist, we must create ProjectMembership link and send invitation


      begin
        u = User.invite!(:email => email)
      rescue
        raise u.errors.to_json
      end

      #Rails.logger.info "*** ***"
      #Rails.logger.info u.to_json
      #Rails.logger.info "*** ***"
      #
      pm = ProjectMembership.new(:user => u, :project => project, :role => role)

      if pm.save
        flash[:notice] = "User was invited to project"

        client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
        message = "Invited <b>new</b> user with email <b>#{u.email}</b> as #{role}, invitation email was sent!"

        begin
          client[project.name].send('abulafia', message, :color => 'yellow', :notify => false)
        rescue HipChat::UnknownRoom
          client["abulafia"].send('abulafia', "Unknown room#{project.name}", :color => 'red', :notify => true)
        end

      else
        raise pm.errors.to_json
      end
    end
    redirect_to :back
  end

  #kick user
  def destroy
    user = User.find(params[:id])
    project = Project.find(params[:project_id])

    client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
    message = "Kicked out user <b>#{user.fio}</b> from project"


    begin
      client[project.name].send('abulafia', message, :color => 'red', :notify => false)
    rescue HipChat::UnknownRoom
      client["abulafia"].send('abulafia', "Unknown room#{project.name}", :color => 'red', :notify => true)
    end


    ProjectMembership.where(:user_id => params[:id], :project_id => params[:project_id]).delete_all
    redirect_to :back, :notice => "User was kicked out from project!"
  end

  #reinvite_user
  def reinvite
    User.find(params[:user_id]).invite!
    redirect_to :back
  end

end
