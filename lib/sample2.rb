require "rubygems"
require "#{File.dirname(__FILE__}/blather"
require "#{File.dirname(__FILE__}/blather/client/client"
 
EM.run do
  name, password = 'bill@moshputer', 'bill'

  c = Blather::Client.setup(Blather::JID.new(user), pass)
  c.connect
end
