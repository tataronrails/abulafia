class JabberBot
  # To change this template use File | Settings | File Templates.
  attr_accessor :user, :message, :bot, :room, :room_message, :sms_text

  include Rails.application.routes.url_helpers

  def initialize(*args)
    @options = args.extract_options!
    self.user = @options.delete(:user).presence || nil
    self.message = @options.delete(:message).presence || nil
    self.room = @options.delete(:room).presence || nil
    self.room_message = @options.delete(:room_message).presence || nil
    self.sms_text = @options.delete(:sms_text).presence || nil
    self.bot = $hipchat_bot
    self
  end

  def connect
    self.bot.connect
    self.bot.auth(KEYS['bot']['hipchat']['password'])
  end

  def change
    client = HipChat::Client.new(KEYS['bot']['hipchat']['token'])
    Rails.logger.debug "*** Change bot ***"
    KEYS['bot']['hipchat']['jid'].each do |jid|
      unless self.bot.jid.to_s == "#{jid}/none"
        self.bot.close
        $hipchat_bot = Jabber::Client::new(Jabber::JID::new(jid))
        self.bot = $hipchat_bot
        begin
          Rails.logger.debug self.connect
        rescue
          Rails.logger.error "IOError bot error in CHANGE"
          #@flag_of_
          next
        end
        client['abulafia'].send('Bot is change', "his jid #{$hipchat_bot.jid}", :color => 'green', :notify => true)
        break
      end
    end
  end

  def send_message
    Rails.logger.debug "**** Send message ****"
    if self.user.present?
      client = HipChat::Client.new(KEYS['bot']['hipchat']['token'])

      self.user.each do |u|
        begin
          client['abulafia'].send('bot', "List of users to notify ** #{u.login} **,<br/> '#{self.message}'", :color => 'yellow')
        rescue Exception
          Rails.logger.error "Error sending message. #{Exception.to_json}"
        end

        if u.hc_user_id.nil?
          #TODO: send sms
          begin
            client['abulafia'].send('bot', "No hipchat id, send sms", :color => 'yellow', :notify => true)
            sms = SMS.new(number: u.cell, message: self.text_for_sms)
            sms.send!
          rescue
            client['abulafia'].send('bot', "Error send sms!", :color => 'yellow')
          end


          #email send

          #begin
          #  client['abulafia'].send('bot', "send mail becouse no hipchat id", :color => 'yellow', :notify => true)
          #  BotMailer.send_email(u, self.message).deliver
          #rescue
          #  Rails.logger.error "ERROR send!"
          #  client['abulafia'].send('bot', "ERROR send mail", :color => 'red', :notify => true)
          #end
        else
          address ="#{KEYS['bot']['hipchat']['company']}_#{u.hc_user_id}@#{KEYS['bot']['hipchat']['host']}"
          message = Jabber::Message::new(address, self.message)
          message.set_type(:chat)

          KEYS['bot']['hipchat']['jid'].each_index do |jid|
            begin
              @mail_flag = false
              unless self.bot.is_connected?
                self.connect
              end
              sending_robot = self.bot.send(message)
              client['abulafia'].send('bot', "Send notification OK! <br />  To: #{u.login}, <br/>  Message: '#{self.message}'", :color => 'green')
              client['abulafia'].send('bot', sending_robot.to_json, :color => 'green')
            rescue
              @mail_flag = true
              Rails.logger.error "!!!!!!! IOError bot error"
              client['abulafia'].send('bot', "BOT #{jid} is down! IOError", :color => 'red', :notify => true)
              self.change
              next
            end
            break
          end
          if @mail_flag
            # send sms

            begin
              client['abulafia'].send('bot', "bot is down!, send sms", :color => 'yellow', :notify => true)
              sms = SMS.new(number: u.cell, message: self.text_for_sms)
              sms.send!
            rescue
              client['abulafia'].send('bot', "Error send sms!", :color => 'yellow')
            end

            #begin
            #  Rails.logger.error "bots is down!!!"
            #  client['abulafia'].send('bot', "BOT is down! IOError", :color => 'red', :notify => true)
            #  client['abulafia'].send('bot', "send mail", :color => 'yellow', :notify => true)
            #  BotMailer.send_email(u, self.message).deliver
            #rescue
            #  Rails.logger.error "ERROR send!"
            #  client['abulafia'].send('bot', "ERROR send mail", :color => 'red', :notify => true)
            #end
          end
        end


        #begin
        #  sending_robot = robot.send(message)
        #
        #  client['abulafia'].send('bot', "Send notification OK! <br />  To: #{u.login}, <br/>  Message: '#{self.message}'", :color => 'green')
        #  client['abulafia'].send('bot', sending_robot.to_json, :color => 'green')
        #
        #rescue IOError
        #  Rails.logger.error "!!!!!!! IOError bot error"
        #  client['abulafia'].send('bot', "BOT is down! IOError", :color => 'red', :notify => true)
        #
        #  #send notification via email
        #
        #  #BotMailer.send_email(u, self.message).deliver
        #else
        #
        #  Rails.logger.error "Bot error, not IOError bot error exception"
        #  Rails.logger.info "Mail but bot"
        #
        #  #BotMailer.send_email(u, self.message).deliver
        #
        #
        #end

      end

      #send note to project room
      begin
        client[self.room].send('bot', self.room_message, :color => 'yellow', :notify => true)
      rescue
        client['abulafia'].send('bot', "Can not find hipchat room for project \"#{self.room}\"", color: 'red', notify: true)
      end
    end
  end


  def get_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def get_task_url(task)
    "http://#{get_host}#{project_task_url(task.project, task, :only_path => true)}" rescue nil
  end


  def message_for_task(task)
    self.message = "Task assigned to you: \"#{task.title}\" in Project" +
        " \"#{task.project.name}\", "+
        "by #{task.owner.fio}, "
    #"Url: #{get_task_url(task)}"
  end

  def sms_for_task(task)
    self.sms_text = "Task assigned to you Url:  #{get_task_url(task)}"
  end

  def room_message_for_task(task)
    self.room_message = "Task <b>\"#{task.title}\"</b> assigned to user <b>#{self.user.first.login}</b>"
    #" #{gravatar_image_tag(self.user.first.login)}"

    #self.room_message = "Task \"#{task.title}\" assigned to user #{self.user.first.fio}" +
    #    ", Url: #{get_task_url(task)}"
  end

  def room_for_task(task)
    self.room = task.project.name
  end

  def message_for_comment(comment)
    unless comment.commentable.discussable.kind_of?(User)
      self.message = " New comment \"#{comment.comment}\""+
          " by: \"#{comment.user.login}\""+
          ", Discussion: \"#{comment.commentable.title}\""+
          ", Project: \"#{comment.commentable.discussable.project.name}\"" +
          ", Url: #{get_task_url(comment.commentable.discussable)}"
    end
  end

  def sms_for_comment(comment)
    self.sms_text = "New comment in discussion Url: #{get_task_url(comment.commentable.discussable)}"
  end

  def room_message_for_comment(comment)
    self.room_message = "+ comment: \"#{comment.comment}\" in discussion #{get_task_url(comment.commentable.discussable)} by user <b>#{comment.user.login}</b>"
    #self.room_message = "New comment \"#{comment.comment}\" in Discussion: \"#{comment.commentable.title}\"" +
    #    "by user #{comment.user.fio}, Url: #{get_task_url(comment.commentable.discussable)}"
  end

  def room_for_comment(comment)
    unless comment.commentable.discussable.kind_of?(User)
      self.room = comment.commentable.discussable.project.name
    end
  end

end