class ProjectsController < ApplicationController
  load_and_authorize_resource

  def progress
    @activities = PublicActivity::Activity
      .where(:recipient_id => [current_user.projects.map(&:id)])
      .order("created_at DESC")
      .includes(:trackable)
      .page(params[:page]).per(50)
  end

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.includes(:project_managers)#.includes(:users)

    @project_managers = @projects
      .without_departments
      .map {|project| project.project_manager }
      .compact!
      #.uniq!
    @project_managers.uniq! unless @project_managers.blank?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    @sprints = @project.sprints.order("created_at DESC")
    @discussion = @project.discussions.new
    @task = @project.tasks.new
    @project_users = @project.users
    @comments = @project.task_comments.order(:created_at).includes(:task, :user).page(params[:page]).per(10)

    begin
      @task.discussion
    rescue
      @task.discussion.new(:title => "some test descussion")
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
        @projects = current_user.projects.includes(:project_managers)           #need to render index
        format.html { render action: "index" }
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
