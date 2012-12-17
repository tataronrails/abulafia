module TasksHelper
  def list_of_task_types

  end

  def type_icon number
    a = []
    a[0] = "star-empty orange"
    a[1] = "bolt red"
    a[2] = "cogs"
    a[3] = "bullhorn"
    a[4] = "briefcase"
    a[5] = "ok"

    content_tag(:i, "", :class => "icon-#{a[number.to_i]}")
  end
end
