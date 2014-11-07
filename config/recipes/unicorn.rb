namespace :unicorn do

  desc 'The task restarts unicorn'
  task :restart_unicorn, roles: :app do
    stop; sleep 3; start
  end
  after 'deploy:restart', 'unicorn:restart'

end
