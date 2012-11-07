require "rvm/capistrano"
require "bundler/capistrano"

set :application, "teachme"
set :repository,  "git://github.com/Ser1aL/teachme-now.git"
set :rails_env, "production"
set :user, "deploy"
set :deploy_to, "/home/#{user}/rails_apps/#{application}"
set :ssh_options, { :forward_agent => true }
server "50.116.18.84", :app, :web, :db, :primary => true

set :scm, :git
set :keep_releases, 5
set :use_sudo, false
set :rvm_type, :system
set :ruby_version, '1.9.3'
set :rvm_bin_path, "/home/#{user}/.rvm/bin"
set :rvm_path, "/home/#{user}/.rvm"
set :rvm_ruby_string, "ruby-1.9.3-p194@#{application}"

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

before "deploy", "deploy:setup"
after 'deploy:update_code', 'deploy:migrate'
after "deploy:restart", "deploy:cleanup"

