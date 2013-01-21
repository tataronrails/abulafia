class ProjectsController < ApplicationController
  load_and_authorize_resource

  def progress
    @activities = PublicActivity::Activity.where(:recipient_id => [current_user.projects.map(&:id)]).order("created_at DESC")
  end

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


  def users_page
    @project = Project.find(params[:project_id])
    @users = @project.users

    @list_of_roles = ProjectMembership.role.values
    list_of_all_users_emails = User.all.map(&:email)

    users_still_in_project = @project.users.map(&:email)
    @list_of_all_users_emails = list_of_all_users_emails.delete_if { |u| users_still_in_project.include?(u) }
    @invitation_accepted_list = User.invitation_accepted.map(&:email)
  end

  def invite_user
    if params[:invitation][:email].blank?
      redirect_to :back, :notice => "Email field can not be blank!" and return
    end

    email = params[:invitation][:email]
    role = params[:role]
    user = User.where(:email => email).first

    project = Project.find(params[:project_id])

    if User.where(:email => email).exists?
      pm = ProjectMembership.new(:user => user, :project => project, :role => role)

      if pm.save
        flash[:notice] = "User now can see current project"

        client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
        message = "Invited existed user <b>#{user.fio}</b> to project as #{role}"
        client[project.name].send('abulafia', message, :color => 'yellow', :notify => false)


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

  # GET /projects
  # GET /projects.json
  def index
    number = "9033196728"
    text_for_sms = "bla bla bla"

    Rails.logger.info sms = SMS.new(number: number, message: text_for_sms)
    Rails.logger.info  sms.send!

    @projects = current_user.projects

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show

    @project = Project.find(params[:id])
    @discussion = @project.discussions.new
    @task = @project.tasks.new
    @project_users = @project.users
    #.delete_if{|u| u==current_user}

    begin
      @task.discussion
    rescue
      @task.discussion.create(:title => "some test descussion")
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    projects_factory = ProjectsFactory.new(user: current_user, project: Project.new(params[:project]))
    projects_factory.create_project!
    @project = projects_factory.project
    respond_to do |format|
      if projects_factory.project_saved?
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

end
