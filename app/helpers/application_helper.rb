module ApplicationHelper

  def favicon40 user
    #gravatar_image_tag(user.email)
  end



  def type_icon number
    unless number
      number = 500
    end

    a = []
    a[500] = "file"
    a[0] = "star-empty orange"
    a[1] = "bolt red"
    a[2] = "cogs"
    a[3] = "calendar yellowgreen"
    a[4] = "briefcase"
    a[5] = "file light-gray"
    a[6] = "star-half"


    content_tag(:i, "", :class => "icon-#{a[number.to_i]}")
  end



end
