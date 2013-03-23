class Users::TasksController < ItemsController
  load_and_authorize_resource :user
  load_and_authorize_resource :task, :through => :user

  belongs_to :user

  actions :index

  def index
    @projects = Project.where(:id => [@tasks.map(&:project_id).uniq]).includes(:tasks).order("name DESC")
    @tasks = Task.where(:assigned_to => current_user, :project_id => @projects.map(&:id))
                 .includes(:owner, :discussion)
                 .order(:created_at).delete_if do |t|
                  (t.status == 2) || (t.finished_at.present?) || (t.hours_worked_on_task.present?)
    end
    @comments_count = Task.where(:id => @tasks.map(&:id)).joins(:comments).group("tasks.id").count("comments.id")
    index!
  end

  private

  def end_of_association_chain
    super.order(:created_at)
  end
end