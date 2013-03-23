class Users::TasksController < ItemsController
  load_and_authorize_resource :user
  load_and_authorize_resource :task, :through => :user

  belongs_to :user

  actions :index

  def index
    @task_projects = @tasks.includes(:project).group_by(&:project)
    index!
  end

  private

  def end_of_association_chain
    super.order(:created_at)
  end
end