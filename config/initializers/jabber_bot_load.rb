jid = KEYS['bot']['hipchat']['jid'][0]
$hipchat_bot = Jabber::Client::new(Jabber::JID::new(jid))
