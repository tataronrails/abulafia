class Projects::SprintsController < InheritedResources::Base
  belongs_to :project

  load_and_authorize_resource :project
  load_and_authorize_resource :sprint, :through => :project

  respond_to :html, :js, :json

  actions :create, :show, :index, :update

  layout 'user_stories', only: :user_stories

  def create
    create! do |success, failure|
      success.js { render @project.sprints.last}
      failure.js { render :js => 'error' }
    end
  end

  private

  def resource
    @sprint = @project.sprints.find_by_iteration_number! params[:id]
  end
end
