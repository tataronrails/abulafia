class TasksController < ApplicationController

  skip_authorization_check


  def update_order
    project = Project.find(params[:project_id])
    position_array = params[:position_array]

    order = ColumnOrder.find_or_initialize_by_project_id(project.id)
    order.position_array = position_array

    task = project.backlog.first


    if order.save
      respond_to do |format|
        format.js {
          render :js => "window.update_backlog_in_us_page(#{project.id}, 'nil');"
        }
      end
    end


  end

  def to_backlog
    task_id = params[:task_id]
    task = Task.find(task_id)
    project_id = task.project.id


    if ColumnOrder.where(:project_id => project_id).present?
      position_array_1 = ColumnOrder.where(:project_id => project_id).first.position_array
      position_array = [position_array_1].unshift(task_id).join(",")

    else
      #position_array_1 = Project.find(project_id).backlog.map(&:id)
      #position_array_1.delete(task_id)
      #position_array = position_array_1.unshift(task_id).join(",")
      array_position = []
      array_position[0] = task_id.to_i
      position_array = array_position[0]
    end


    order = ColumnOrder.find_or_initialize_by_project_id(project_id)
    order.place_id = 1
    order.position_array = position_array
    order.project_id = project_id

    order.save!

    #raise order.position_array.to_json


    respond_to do |format|
      format.js {
        if task.update_attributes(:place => 1)
          render :js => "console.log(#{position_array}); window.update_icebox_in_us_page(#{project_id}); window.update_backlog_in_us_page(#{project_id},#{task_id});"
        end
      }
    end
  end


  def update_points
    points = params[:points]
    task_id = params[:task_id]

    task = Task.find(task_id)

    #tasks = task.project.tasks
    project = task.project


    respond_to do |format|
      format.js {

        if params[:status]
          task.status = params[:status]
          task.place = task.place+1

          if params[:status].to_i == 2 #start button pressed
            task.assigned_to = current_user.id #if any user pressed START, then task will assign to this user
          end


          if task.save!
            #render :partial => "projects/stories_all", :locals => {:project => project, :user => current_user, :task => task}
            render :js => "window.update_my_work_in_us_page(#{project.id}); window.update_backlog_in_us_page(#{project.id});"
          else
            render :js => "alert('error)"
          end
        else

          if task.update_attributes(:start => Time.now, :estimate => points, :status => "1")
            render :partial => "projects/stories_all", :locals => {:project => project, :user => current_user, :task => task}
          else
            render :js => "alert('error)"
          end
        end
      }
    end


  end

  def add_new_comment
    task = Task.find(params[:id])
    comment = params[:task][:comment]
    user = params[:user_id]

    task.discussion.comments.create(:comment => comment, :user_id => user)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        render :partial => "comments", :locals => {:comments => task.discussion.comments}
      }
    end

  end

  def show
    @task = Task.find(params[:id])
    @project_users = @task.project.users.map(&:login)
  end

  def create
    @project = Project.find(params[:task][:project_id])
    @task = @project.tasks.new
    @task.title = params[:task][:title]
    @task.assigned_to = params[:task][:assigned_to] if params[:task][:assigned_to].present?
    @task.owner_id = current_user.id
    #@task = @project.tasks.new(:title => params[:task][:title], :assigned_to => User.where(:email => params[:assigned_to]).first.id, :owner_id => current_user.id)

    if @task.save
      respond_to do |format|
        format.js {
          if params[:assigned_to].present?
            gflash :success => "Task successfully assigned to #{User.where(:email => params[:assigned_to]).first.login}"
          else
            gflash :success => "Alone task successfully created"
          end

          render :partial => "projects/stories_all", :locals => {:project => @project, :user => current_user, :task => @task}
        }

      end
    else
      flash[:notice] = "Error task creating"
    end

  end
end