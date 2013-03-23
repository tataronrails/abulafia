# encoding: UTF-8
class Projects::TasksController < ItemsController
  belongs_to :project

  skip_authorization_check

  load_and_authorize_resource :project
  load_and_authorize_resource :task, :through => :project

  actions :all, :except => [:new, :index]

  def create
    @task.owner_id = current_user.id
    create! do |success, failure|
      success.js { render :partial => 'projects/stories_all', :locals => {project: @project, user: current_user, task: @task} }
    end
  end

  def show
    #TODO Переместить куда-нить это условие...
    if @task.assigned_to
      @strikes = Strike.where(:user_id => @task.assigned_user.id, :task_id => @task.id).order('date_of_assignment DESC')
    end
    show!
  end

  def update
    #params[:task].delete(:sprint_id) unless (can? :manage_sprints, @task)
    update! do |success, failure|
      success.html { redirect_to project_task_path(@task.project, @task), notice: 'Task was successfully updated.' }
      success.json { render json: @task.to_json(:methods => :status_events) }

      failure.html { render action: :edit }
      failure.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to project_path(@project) }
      format.js   { render :partial => 'projects/stories_all', :locals => {project: @project, user: current_user, task: @task} }
    end
  end

  ###################
  def my
    tasks = current_user.my_tasks
    @projects = Project.where(:id => [tasks.map(&:project_id).uniq]).order("name DESC")

  end

  def sms_ping
    task = Task.find(params[:task_id])
    assigned_user = task.assigned_to_user
    cell = assigned_user.cell


    sms = SMS.new(number: cell, message: "Как дела в задаче: \"#{task.title}\"?,  #{current_user.fio}")

    if sms.send!
      flash[:notice] = "OK"
      render :nothing => true
    else
      flash[:notice] = "Error sending SMS!"

      respond_to do |format|
        format.js {
          render :js => "alert('#{flash[:notice]}')" and return
        }
      end
    end


  end


  def accept_to_start
    task = Task.find(params[:task_id])

    if task.update_attribute(:accepted_to_start, Time.now)
      #TODO: hc notofication here
      client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
      message = "Accepted by : \"#{User.find(task.assigned_to).fio}\", Task: \"#{task.title}\""
      client[task.project.name].send('task bot', message, :color => 'green', :notify => false)

      task.create_activity key: 'Task.accept_to_start', owner: User.find(task.assigned_to), params: {message: message}

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
end