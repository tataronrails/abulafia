module ApplicationHelper

  def favicon40 user
    #gravatar_image_tag(user.email)
  end

  def user_icon(user, size = 40, options = {})
    gravatar_image_tag(user.email, :class => options[:class], :title => user.fio, :gravatar => { :size => size })
  end

  def page_title
    @page_title ? "#{@page_title} - Abulafia" : "Abulafia"
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

  def bootstrap_input(f, label_field, title = nil)
    capture_haml do
      haml_tag :div, :class => "control-group" do
        label_args = [label_field, title, :class => 'control-label'].compact
        haml_concat(f.label(*label_args))
        haml_tag :div, :class => "controls" do
          yield
        end
      end
    end
  end
end
