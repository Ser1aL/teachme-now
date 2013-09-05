require 'rvm/capistrano'
require 'bundler/capistrano'
# load 'deploy/assets'

set :application, 'teach-me'
set :repository,  'git@github.com:Ser1aL/teachme-now.git'
set :rails_env, 'production'
set :user, 'deploy'
set :deploy_to, "/opt/#{application}"
set :ssh_options, { :forward_agent => true }
set :bundle_without, [:development, :test]
set :bundle_dir, nil
set :bundle_flags, nil
set :bundle_cmd, "LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8' bundle"

server '106.186.27.239', :app, :web, :db, :primary => true

set :branch, 'master'

set :scm, :git
set :keep_releases, 5
set :use_sudo, false
set :rvm_type, :system
set :ruby_version, '1.9.3'
set :rvm_bin_path, "/home/#{user}/.rvm/bin"
set :rvm_path, "/home/#{user}/.rvm"
set :rvm_ruby_string, "ruby-1.9.3-p448"

set :asset_env, "RAILS_GROUPS=assets,development"

set :shared_children, shared_children + %w{public/uploads}

require 'capistrano-unicorn'

namespace :deploy do
  task :db_seed do
    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:seed}
  end

  task :default_quotes do
    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:add_quotes}
  end
end

after 'deploy:update_code', 'deploy:migrate'
after 'deploy:restart', 'deploy:cleanup'

