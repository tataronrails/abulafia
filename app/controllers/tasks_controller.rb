class TasksController < ApplicationController
  load_and_authorize_resource :task

  def accept_to_start
    task = Task.find(params[:task_id])
    if task.update_attribute(:accepted_to_start, Time.now)
      flash[:notice] = "Started"
      respond_to do |format|

        format.js {
          render :text => "Accepted!"
        }
      end
    else
      flash[:notice] = "Error"
    end
  end

  def finish_work
    task = Task.find(params[:task_id])
    if task.update_attribute(:finished_at, Time.now)
      flash[:notice] = "Finished"
      respond_to do |format|

        format.js {
          render :text => "Done!"
        }
      end

    else
      flash[:notice] = "Error"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    @project = @task.project

    respond_to do |format|
      format.js {
        render :partial => "projects/stories_all", :locals => {:project => @project, :user => current_user, :task => @task}
      }
      format.html{
        redirect_to project_path(@project)
      }
    end
  end


  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  end


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
      array_position = []
      array_position[0] = task_id.to_i
      position_array = array_position[0]
    end


    order = ColumnOrder.find_or_initialize_by_project_id(project_id)
    order.place_id = 1
    order.position_array = position_array
    order.project_id = project_id

    order.save!

    respond_to do |format|
      format.js {
        if task.update_attributes(:place => 1)
          render :js => "window.update_icebox_in_us_page(#{project_id}); window.update_backlog_in_us_page(#{project_id},#{task_id});"
        end
      }
    end
  end


  def update_hours_spend_on_task
    hours_worked_on_task = params[:hours_worked_on_task]
    task_id = params[:task_id]


    task = Task.find(task_id)
    project = task.project

    task.hours_worked_on_task = hours_worked_on_task.to_i
    task.status = 5

    column_order_before = ColumnOrder.where(:project_id => project.id, :place_id => 1).first
    column_order = column_order_before.position_array.split(",")
    column_order.delete(task_id)

    column_order2 = column_order.join(",")

    column_order_before.update_attribute(:position_array, column_order2)


    respond_to do |format|
      format.js {

        if task.save!
          render :js => "window.update_current_work_in_us_page(#{project.id}); window.update_backlog_in_us_page(#{project.id});"
        else
          render :js => "alert('error)"
        end
      }
    end
  end


  def update_points
    points = params[:points]
    task_id = params[:task_id]

    task = Task.find(task_id)

    project = task.project


    respond_to do |format|
      format.js {

        if params[:status]
          task.status = params[:status]
          task.place = task.place+1

          if params[:status].to_i == 2 #start button pressed
            task.assigned_to = current_user.id #if any user pressed START, then task will assign to this user
          end


          #raise task.valid?.to_json

          if task.save!
            #render :partial => "projects/stories_all", :locals => {:project => project, :user => current_user, :task => task}

            #render :js => "#{task.valid?.to_json}"
            render :js => "window.update_current_work_in_us_page(#{project.id}); window.update_backlog_in_us_page(#{project.id});"
          else
            render :js => "alert('error)"
          end
        else

          if task.update_attributes(:start => Time.now, :estimate => points, :status => "1")
            render :nothing => true
            #render :partial => "projects/stories_all", :locals => {:project => project, :user => current_user, :task => task}
          else
            render :js => "alert('error)"
          end
        end
      }
    end
  end

  #
  #def add_new_comment
  #
  #end
  def add_new_comment
    task = Task.find(params[:id])
    comment = params[:task][:comment]
    user = params[:user_id]

    task.discussion.comments.create(:comment => comment, :user_id => user)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        render :partial => task.discussion.comments
      }
    end
  end

  def show
    @task = Task.find(params[:id])
    @project_users = @task.project.users.map(&:login)
    @assigned_to = User.find(@task.assigned_to).email if @task.assigned_to
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
          #if params[:assigned_to].present?
          #gflash :success => "Task successfully assigned to #{User.where(:email => params[:assigned_to]).first.login}"
          #else
          #gflash :success => "Alone task successfully created"
          #end


          render :partial => "projects/stories_all", :locals => {:project => @project, :user => current_user, :task => @task}
        }

      end
    else
      flash[:notice] = "Error task creating"
    end

  end
end