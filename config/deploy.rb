require 'rvm/capistrano'
require 'bundler/capistrano'
# load 'deploy/assets'
require 'capistrano-resque'

load 'config/recipes/unicorn'
load 'config/recipes/resque_scheduler'

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

server '106.186.27.239', :app, :web, :db, :resque_worker, :resque_scheduler, :primary => true

set :branch, 'master'

set :scm, :git
set :keep_releases, 5
set :use_sudo, false
set :rvm_type, :system
set :ruby_version, '2.1'
set :rvm_bin_path, "/home/#{user}/.rvm/bin"
set :rvm_path, "/home/#{user}/.rvm"
set :rvm_ruby_string, 'ruby-2.1.2'

set :asset_env, "RAILS_GROUPS=assets,development"

set :workers, { 'mailer_queue' => 1, 'pro_queue' => 1 }

set :shared_children, shared_children + %w{public/uploads public/pdf_receipts public/qr_codes}

require 'capistrano-unicorn'

ENV['RACK_ENV'] = 'production'

set :unicorn_env, 'unicorn'
set :unicorn_rack_env, 'production'

namespace :deploy do
  task :db_seed do
    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:seed}
  end

end

after 'deploy:update_code', 'deploy:migrate'
after 'deploy:restart', 'deploy:cleanup', 'resque:scheduler:stop', 'resque:restart', 'resque:scheduler:start'
