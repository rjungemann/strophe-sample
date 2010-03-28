desc ""
task :install do
	sh "mkdir vendor" unless File.exists? "vendor"

	sh "gem install xmpp4r --no-ri --no-rdoc"
	
	sh "cd vendor && git clone git://github.com/sprsquish/blather.git"

	sh "cd vendor && git clone git://code.stanziq.com/strophejs && make"
	sh "cp vendor/strophejs/strophe.js ../scripts/"

	sh "cd vendor && curl -O http://www.flensed.com/code/releases/flXHR-1.0.5.tar.gz"
	sh "cd vendor && tar zxf flXHR-*.tar.gz && rm flXHR-*.tar.gz"
	sh "cp vendor/flensed-*/deploy/* ../scripts/"
end

desc ""
task :clean do
	sh "rm -rf vendor"
	sh "rm public/scripts/*.js"
end

namespace :openfire do
	desc ""
	task :install do
		sh "mkdir vendor" unless File.exists? "vendor"
	
		sh "cd vendor && svn co http://svn.igniterealtime.org/svn/repos/openfire/trunk openfire"
		sh "cd vendor/openfire/build && ant"
		sh "cd vendor/openfire/target/openfire/bin && chmod 777 openfire*"
	end

	desc ""
	task :clean do
		sh "rm -rf vendor/openfire" if File.exists? "vendor/openfire"
		sh "rm tmp/openfire.dtach" if File.exists? "tmp/openfire.dtach"
	end

	desc ""
	task :start do
		sh "dtach -n tmp/openfire.dtach vendor/openfire/target/openfire/bin/openfire.sh start"
	end

	desc ""
	task :stop do
		sh %{kill `lsof -i :9090 | ruby -e "STDIN.gets; puts STDIN.gets.split[1]"`}
	end

	desc ""
	task :restart => [:stop, :start]
end
