var App = {
  connection: null,
  start_time: null,
  log: function(msg) { $('#log').append("<p>" + msg + "</p>"); },
  commands: {
		send_ping: function(to) {
		  var ping = $iq({ to: to, type: "get", id: "ping1" }).
		  	c("ping", { xmlns: "urn:xmpp:ping" });

		  App.log("Sending ping to " + to + ".");

		  App.start_time = (new Date()).getTime();
		  App.connection.send(ping);
		}
  },
  events: {
		connected: function(ev, data) {
			var conn = new Strophe.Connection("http://localhost:7070/http-bind/");

			conn.connect(data.jid, data.password, function(status) {
				if(status === Strophe.Status.CONNECTED)
				  $(document).trigger('connected');
				else if(status === Strophe.Status.DISCONNECTED)
				  $(document).trigger('disconnected');
			});
			App.connection = conn;

			App.log("Connection established."); // inform the user

			var domain = Strophe.getDomainFromJid(App.connection.jid);

			App.connection.addHandler(App.events.handle_pong,	null, "iq", null, "ping1");
			App.commands.send_ping(domain);
		},
		handle_pong: function(iq) {
		  var elapsed = (new Date()).getTime() - App.start_time;

		  App.log("Received pong from server in " + elapsed + "ms.");

		  App.connection.disconnect();
		  
		  return false;
		},
		disconnected: function() {
			App.log("Connection terminated.");

			App.connection = null; // remove dead connection object
		}
  }
};
$(document).bind('connect', App.events.connected);
$(document).bind('disconnected', App.events.disconnected);
