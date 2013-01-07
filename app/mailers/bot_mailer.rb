class BotMailer < ActionMailer::Base
  default from: "botofabulafia@gmail.com"


  def send_email(user, message)
    @user = user
    @message = message
    #@url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Abulafia notification: "+message)
  end
end
