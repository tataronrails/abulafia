login = KEYS['bot']['gmail'][0]
pass = KEYS['bot']['gmail'][1]
GTALK_BOT = Jabber::Client::new(Jabber::JID::new(login))
GTALK_BOT.connect
GTALK_BOT.auth(pass)

login = KEYS['bot']['hipchat'][0]
pass = KEYS['bot']['hipchat'][1]
HIPCHAT_BOT = Jabber::Client::new(Jabber::JID::new(login))
HIPCHAT_BOT.connect
HIPCHAT_BOT.auth(pass)




