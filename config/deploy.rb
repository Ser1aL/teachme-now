require "rvm/capistrano"
require "bundler/capistrano"
#load 'deploy/assets'

set :application, "teachme"
set :repository,  "git@github.com:Ser1aL/teachme-now.git"
set :rails_env, "production"
set :user, "deploy"
set :deploy_to, "/home/#{user}/rails_apps/#{application}"
set :ssh_options, { :forward_agent => true }
set :bundle_without, []
set :bundle_dir, nil
set :bundle_flags, nil

server "50.116.18.84", :app, :web, :db, :primary => true

set :branch, "master"

set :scm, :git
set :keep_releases, 5
set :use_sudo, false
set :rvm_type, :system
set :ruby_version, '1.9.3'
set :rvm_bin_path, "/home/#{user}/.rvm/bin"
set :rvm_path, "/home/#{user}/.rvm"
set :rvm_ruby_string, "ruby-1.9.3-p194"

set :asset_env, "RAILS_GROUPS=assets,development"

set :shared_children, shared_children + %w{public/uploads}

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

namespace :deploy do
  task :db_seed do
    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:seed}
  end
end

before "deploy", "deploy:setup"
after 'deploy:update_code', 'deploy:migrate'
after "deploy:restart", "deploy:cleanup"

