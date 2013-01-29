class SprintsController < ApplicationController
  load_and_authorize_resource

  def new
    @sprint = Sprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sprint }
    end
  end


  def create
    project = Project.find(params[:project_id])
    sprint = project.sprints.new(params[:new_spring])

    respond_to do |format|
      if sprint.save!
        format.js { head :ok }
      else
        format.js { render :js => "error" }
      end
    end
  end
end
