module ProjectsHelper
  def label_color status
      a = []
      a[0] = " "
      a[1] = "label-success"
      a[2] = "label-info"
      a[3] = "label-success"
      a[4] = "label-success"

    a[status]
  end
end
