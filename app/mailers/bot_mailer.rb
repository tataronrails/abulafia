class BotMailer < ActionMailer::Base
  default from: "botofabulafia@gmail.com"


  def assigned_user_message(user, message)
    @user = user
    #@url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Notification from abulafia")
  end
end
