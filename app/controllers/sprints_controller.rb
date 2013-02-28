class SprintsController < InheritedResources::Base
  belongs_to :project

  load_and_authorize_resource :project
  load_and_authorize_resource :sprint, :through => :project

  respond_to :html, :json, :js

  before_filter :authorize_parent

  respond_to :html, :js, :json

  actions :create, :show, :index, :update

  layout 'user_stories', only: :user_stories

  def create
    create! do |format|
      if @sprint.errors.empty?
        format.js { render parent.sprints.last}
      else
        format.js { render :js => "error" }
      end
    end
  end

  private

  def resource
    @sprint = parent.sprints.find_by_iteration_number! params[:id]
  end

  def authorize_parent
    authorize! :read, parent
  end
end
