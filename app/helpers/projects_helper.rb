module ProjectsHelper
  def get_user_stories_path project
    if project.current_sprint.present?
      project_tasks_path( project,  by_sprint: project.current_sprint.id)
    else
      project_user_stories_path(project)
    end
  end

  def label_color status
    a = []
    a[0] = " "
    a[1] = "label-success"
    a[2] = "label-info"
    a[3] = "label-inverse"
    a[4] = "label-important"
    a[5] = "label-info"
    a[6] = "label"

    a[status]
  end

  def users_initials user_id
      user = User.find(user_id)
    if user && user.initials
      user.initials
    else
      'Me'
    end


  end
end
