# encoding: UTF-8
class TasksController < InheritedResources::Base
  skip_authorization_check
  actions :index

  def index
    tasks = current_user.my_tasks
    @projects = Project.where(:id => [tasks.map(&:project_id).uniq]).includes(:tasks).order("name DESC")
    @tasks = Task
    .where(:assigned_to => current_user, :project_id => @projects.map(&:id))
    .includes(:owner, :discussion)
    .order(:created_at).delete_if do |t|
      (t.status == 2) || (t.finished_at.present?) || (t.hours_worked_on_task.present?)
    end
    @comments_count = Task.where(:id => @tasks.map(&:id)).joins(:comments).group("tasks.id").count("comments.id")
  end
end