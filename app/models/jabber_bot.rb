class JabberBot
  # To change this template use File | Settings | File Templates.
  attr_accessor :user, :message

  def initialize(*args)
    @options = args.extract_options!
    self.user  = @options.delete(:user ).presence || nil
    self.message  = @options.delete(:message ).presence || nil
    self
  end

  def send_message
    if self.user.hc_user_id.nil?
      login = BOTCONFIG['gmail'][0]
      pass = BOTCONFIG['gmail'][1]
      adress = self.user.email
    else
      login = BOTCONFIG['hipchat'][0]
      pass = BOTCONFIG['hipchat'][1]
      adress ="#{BOTCONFIG['hipchat'][2]}_#{self.user.hc_user_id}@#{BOTCONFIG['hipchat'][3]}"
    end
    robot = Jabber::Client::new(Jabber::JID::new(login))
    robot.connect
    robot.auth(pass)
    message = Jabber::Message::new(adress, self.message)
    message.set_type(:chat)
    robot.send message
  end

  #jb = JabberBot.new( :user => user12, :message => "drgdrgdfgdf")
  #jb.senmd_message
end