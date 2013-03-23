class ProjectsController < ItemsController
  load_and_authorize_resource

  actions :all, :except => :new

  def create
    @project.project_memberships.build :user => current_user, :role => 'admin'
    create! do |success, failure|
      success.html { redirect_to @project, notice: 'Project was successfully created.' }
      success.json { render json: @project, status: :created, location: @project }
      failure.html { redirect_to projects_path, alert: 'Error.' }
      failure.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to @project, notice: 'Project was successfully updated.' }
      success.json { head :no_content }
      failure.html { render action: :edit }
      failure.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end

  ######

  def update_icebox
    project = Project.find(params[:project_id])
    render :partial => "projects/story", :locals => {:tasks => project.icebox, :place => "icebox", :updated_task => nil}
  end

  def update_backlog
    task_id = params[:task_id]
    project = Project.find(params[:project_id])
    render :partial => "projects/story", :locals => {:tasks => project.backlog, :place => "backlog", :updated_task => task_id}
  end

  def update_current_work
    project = Project.find(params[:project_id])
    render :partial => "projects/story", :locals => {:tasks => project.current_work, :place => "current_work", :updated_task => nil}
  end

  def update_my_work
    project = Project.find(params[:project_id])
    render :partial => "projects/story", :locals => {:tasks => project.my_work(current_user), :place => "my_work", :updated_task => nil}
  end

  def user_stories
    @project = Project.find(params[:project_id])
    render :layout => "user_stories"
  end

  def kick_out_users
    user = User.find(params[:user_id])
    project = Project.find(params[:project_id])

    client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
    message = "Kicked out user <b>#{user.fio}</b> from project"


    begin
      client[project.name].send('abulafia', message, :color => 'red', :notify => false)
    rescue HipChat::UnknownRoom
      client["abulafia"].send('abulafia', "Unknown room#{project.name}", :color => 'red', :notify => true)
    end


    ProjectMembership.where(:user_id => params[:user_id], :project_id => params[:project_id]).delete_all
    redirect_to :back, :notice => "User was kicked out from project!"
  end

  def invite_user
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

  def reinvite_user
    #TODO: recreate another way


    User.find(params[:user_id]).invite!
    redirect_to :back

    #email = User.where(:id => params[:user_id]).first.email
    #role = ProjectMembership.where(:user_id => params[:user_id], :project_id => params[:project_id]).first.role
    #project = Project.find(params[:project_id])
    #
    #ProjectMembership.where(:user_id => params[:user_id], :project_id => params[:project_id]).delete_all
    #User.where(:id => params[:user_id]).delete_all
    #
    #User.invite!(:email => email)
    #pm = ProjectMembership.new(:user => User.where(:email => email).first, :project => project, :role => role)
    #if pm.save
    #  flash[:notice] = "User was reinvited to project"
    #end
    #
    #redirect_to :back
  end

  private

  def begin_of_association_chain
    current_user
  end
end
