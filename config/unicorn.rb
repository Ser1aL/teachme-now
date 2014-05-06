application = 'teach-me'
environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'production'
app_path =  "/opt/#{application}"

timeout 30
preload_app true
if environment == 'production'
  worker_processes 2
elsif environment == 'staging'
  worker_processes 1
else
  worker_processes 1
end

listen "/tmp/unicorn-teach-me-#{environment}.sock", :backlog => 64

# Hard-set the CWD & pidfile to ensure app-reloading consistency
if %w(production staging).include?(environment)
  working_directory "#{app_path}/current"
  shared_path = "#{app_path}/shared"
else
  working_directory app_path
  shared_path = app_path
end

stderr_path "#{shared_path}/log/unicorn_#{environment}.stderr.log"
pid "#{shared_path}/pids/unicorn.pid"

# Rails breaks unicorn's logger formatting, reset it
# http://rubyforge.org/pipermail/mongrel-unicorn/2010-October/000732.html
Unicorn::Configurator::DEFAULTS[:logger].formatter = Logger::Formatter.new

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end