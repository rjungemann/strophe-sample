require 'sinatra/base'

module StropheSample
	class App < Sinatra::Base
		set :public, "#{::File.dirname(__FILE__)}/public"
	end
end

run StropheSample::App.new
