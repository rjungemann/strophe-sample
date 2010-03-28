# sample code from http://www.rubyfleebie.com/im-integration-with-xmpp4r-part-2/

require 'xmpp4r'
require 'xmpp4r/roster'
require 'xmpp4r/muc/helper/mucclient'

$users = [
	["bill@moshputer", "bill"],
	["jane@moshputer", "jane"],
	["mary@moshputer", "mary"]
]
$rooms = [["splosion@conference.moshputer", nil]]

# signin
name, password = *$users.first
c = Jabber::Client.new Jabber::JID::new(name)
c.connect
c.auth password

# set status to available
c.send(Jabber::Presence.new.set_type(:available))

# subscribe to another user
roster = Jabber::Roster::Helper.new(c)
roster.add_subscription_request_callback do |item, pres| 
  roster.accept_subscription(pres.from)
end

# send a subscription request to the other user
pres = Jabber::Presence.new.set_type(:subscribe).set_to($users[1][0])
c.send(pres)

# wait for the other user to subscribe back, then send a confirmation message
c.add_update_callback do |presence|
  if presence.from == $users[1][0] && presence.ask == :subscribe
  	client.send(presence.from, "I am so very happy you have accept my request, Jane!")
	end
end

# send message to other user
msg = Jabber::Message::new($users[1][0], "Hello... Jane?")
msg.type = :chat
c.send(msg)

# recieve a message from another user
c.add_message_callback do |m|
	puts m.body if m.from == $users[1][0]
end

# respond to another user's change in presence
c.add_presence_callback do |old_presence, new_presence|
  if new_presence.from == $users[1][0] && new_presence.show == :dnd
  	msg = Jabber::Message::new($users[1][0], "Jane... I know you don't want to be bothered (dnd = do not disturb) but I just wanted to say HI anyway!")
  	msg.type = :chat
  	client.send(msg)
  end
end

# join chat room
muc = Jabber::MUC::MUCClient.new(c)
muc.my_jid = name
muc.join("#{$rooms[0][0]}/Billy")

# send message to chat room
muc.send Jabber::Message::new(nil, 'Hello everybody!')

# wait for connection timeout, then close connection and exit
t = Thread.new { sleep Jabber::XMPP_REQUEST_TIMEOUT; Thread.main.wakeup; }
Thread.stop
c.close
