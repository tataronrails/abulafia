class JabberBot
  require 'hipchat-api'
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
    hipchat_api = HipChat::API.new('94ecc0337c81806c0d784ab0352ee7')
    #if self.user.present?
    #  login = KEYS['bot']['gmail'][0]
    #  pass = KEYS['bot']['gmail'][1]
    #  gtalk_bot = Jabber::Client::new(Jabber::JID::new(login))
    #  gtalk_bot.connect
    #  gtalk_bot.auth(pass)
    #
    #  login = KEYS['bot']['hipchat'][0]
    #  pass = KEYS['bot']['hipchat'][1]
    #  hipchat_bot = Jabber::Client::new(Jabber::JID::new(login))
    #  hipchat_bot.connect
    #  hipchat_bot.auth(pass)
    #
    #  self.user.each  do |u|
    #    if u.hc_user_id.nil?
    #      robot = gtalk_bot
    #      adress = u.email
    #    else
    #      robot = hipchat_bot
    #      adress ="#{KEYS['bot']['hipchat'][2]}_#{u.hc_user_id}@#{KEYS['bot']['hipchat'][3]}"
    #    end
    #    message = Jabber::Message::new(adress, self.message)
    #    message.set_type(:chat)
    #    robot.send message
    #  end
    #
    #  gtalk_bot.close
    #  hipchat_bot.close
    #end
    rooms = hipchat_api.rooms_list
    #raise rooms.to_json
    #room_id = "#{KEYS['bot']['hipchat'][2]}_#{self.user.hc_user_id}"
    #raise (room = hipchat_api.rooms_create('abulafia' , self.user.hc_user_id, privacy = 'private', topic = '', guest_access = 0)).to_json

    room_id = rooms[:rooms].find(:name => 'abulafia').first.room_id
    message = self.message
    from = 'abulafia'
    raise (hipchat_api.rooms_message(room_id, from, message, notify = 0, color = 'yellow', message_format = 'html')).to_json
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