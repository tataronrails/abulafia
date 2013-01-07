class JabberBot
  # To change this template use File | Settings | File Templates.
  attr_accessor :user, :message

  include Rails.application.routes.url_helpers

  def initialize(*args)
    @options = args.extract_options!
    self.user = @options.delete(:user).presence || nil
    self.message = @options.delete(:message).presence || nil
    self
  end

  def send_message
    Rails.logger.debug "**** Send message ****"

    if self.user.present?

      #login = KEYS['bot']['gmail'][0]
      #pass = KEYS['bot']['gmail'][1]
      #gtalk_bot = Jabber::Client::new(Jabber::JID::new(login))
      #gtalk_bot.connect
      #gtalk_bot.auth(pass)

      login = KEYS['bot']['hipchat'][0]
      pass = KEYS['bot']['hipchat'][1]
      hipchat_bot = Jabber::Client::new(Jabber::JID::new(login))
      hipchat_bot.connect

      client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")

      begin
        hipchat_bot.auth(pass)
      rescue Exception
        Rails.logger.error "Error sending message. #{Exception.to_json}"
      end


      #if auth
      #  client['abulafia'].send('bot', "Message delivered successfully )", :color => 'yellow')
      #else
      #  client['abulafia'].send('!!!bot error', "Error: #{auth.to_json}", :color => 'red', :notify => true)
      #end

      #raise self.user.count


      self.user.each do |u|

        begin
          client['abulafia'].send('bot', "List of users to notify ** #{u.login} **,<br/> '#{self.message}'", :color => 'yellow')
        rescue Exception
          Rails.logger.error "Error sending message. #{Exception.to_json}"
        end


        p robot = hipchat_bot
        p address ="#{KEYS['bot']['hipchat'][2]}_#{u.hc_user_id}@#{KEYS['bot']['hipchat'][3]}"

        p message = Jabber::Message::new(address, self.message)
        p message.set_type(:chat)

        begin
          sending_robot = robot.send(message)

          client['abulafia'].send('bot', "Send notification OK! <br />  To: #{u.login}, <br/>  Message: '#{self.message}'", :color => 'green')
          client['abulafia'].send('bot', sending_robot.to_json, :color => 'green')

        rescue IOError
          Rails.logger.error "!!!!!!! IOError bot error"
          client['abulafia'].send('bot', "BOT is down! IOError", :color => 'red', :notify => true)
        end


        #rescue Exception
        #  Rails.logger.error "Send notification error jabber_bot::send_message : #{Exception.to_json}"
        #
        #
        #  begin
        #    client['abulafia'].send('bot', "Send notification error: #{Exception.to_json}", :color => 'red')
        #  rescue Exception
        #    Rails.logger.error "Error sending message. #{Exception.to_json}"
        #  end
        #
        #end


      end


      #self.user.each  do |u|
      #  if u.hc_user_id.nil?
      #    robot = gtalk_bot
      #    address = u.email
      #  else
      #    robot = hipchat_bot
      #    address ="#{KEYS['bot']['hipchat'][2]}_#{u.hc_user_id}@#{KEYS['bot']['hipchat'][3]}"
      #  end
      #  message = Jabber::Message::new(address, self.message)
      #  message.set_type(:chat)
      #  robot.send message
      #end

      #gtalk_bot.close
      hipchat_bot.close
    end
  end


  def get_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def get_task_url(task)
    "http://#{get_host}#{task_url(task, :only_path => true)}"
  end


  def message_for_task(task)

    self.message = "Task assigned to you: \"#{task.title}\" in project " +
        " \"#{task.project.name}\" #{get_task_url(task)}"
  end

  def message_for_comment(comment)
    self.message = "New comment \"#{comment.comment}\""+
        ", Discussion: \"#{comment.commentable.title}\""+
        ", Project: \"#{comment.commentable.discussable.project.name}\"" +
        ", Url: #{get_task_url(comment.commentable.discussable)}"
  end

end