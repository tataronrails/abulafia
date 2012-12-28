class JabberBot
  # To change this template use File | Settings | File Templates.
  attr_accessor :user, :message

  include Rails.application.routes.url_helpers

  def initialize(*args)
    @options = args.extract_options!
    self.user  = @options.delete(:user ).presence || nil
    self.message  = @options.delete(:message ).presence || nil
    self
  end

  def send_message
    if self.user.hc_user_id.nil?
      robot = GTALK_BOT
      adress = self.user.email
    else
      robot = HIPCHAT_BOT
      adress ="#{KEYS['bot']['hipchat'][2]}_#{self.user.hc_user_id}@#{KEYS['bot']['hipchat'][3]}"
    end
    message = Jabber::Message::new(adress, self.message)
    message.set_type(:chat)
    robot.send message
  end


  def get_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def get_task_url(task)
    "http://#{get_host}#{task_url(task, :only_path => true)}"
  end

  def message_for_task(task)
    self.message = "new task assigned to you:  \"#{task.title}\" in project " +
                   " \"#{task.project.name}\" #{get_task_url(task)}"
  end

  def message_for_comment(comment)
    self.message = "new comment in discuss  \"#{comment.commentable.title}\" in" +
                   " project \"#{comment.commentable.discussable.project.name}\" " +
                   " #{get_task_url(comment.commentable.discussable)}"
  end

end