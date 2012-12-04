class ProjectsController < ApplicationController
  load_and_authorize_resource


  def kick_out_users
    ProjectMembership.where(:user_id => params[:user_id], :project_id => params[:project_id]).delete_all
    redirect_to :back, :notice => "User was kicked out from project!"
  end

  def users_page
    @project = Project.find(params[:project_id])
    @users = @project.users

    @list_of_roles = ProjectMembership.role.values
    list_of_all_users_emails = User.all.map(&:email)

    users_still_in_project = @project.users.map(&:email)
    @list_of_all_users_emails = list_of_all_users_emails.delete_if { |u| users_still_in_project.include?(u)}
    @invitation_accepted_list = User.invitation_accepted.map(&:email)
  end

  def invite_user
    if params[:invitation][:email].blank?
      redirect_to :back, :notice => "Email field can not be blank!" and return
    end

    email = params[:invitation][:email]
    role = params[:role]
    project = Project.find(params[:project_id])

    if User.where(:email => email).exists?
      pm = ProjectMembership.new(:user => User.where(:email => email).first, :project => project, :role => role)

      if pm.save
        flash[:notice] = "User now can see current project"
      end

    else
      User.invite!(:email => email)
      flash[:notice] = "User was invited to project"

      ProjectMembership.create(:user => User.where(:email => email).first, :project => project, :role => role)

    end

    redirect_to :back

  end

  # GET /projects
  # GET /projects.json
  def index
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
