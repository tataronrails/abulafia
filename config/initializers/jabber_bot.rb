jid = KEYS['bot']['hipchat']['jid'][1]
#password = KEYS['bot']['hipchat']['password']
$hipchat_bot = Jabber::Client::new(Jabber::JID::new(jid))
#HIPCHATBOT.connect
#HIPCHATBOT.auth(password)